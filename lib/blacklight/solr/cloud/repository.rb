require "zk"
require "blacklight/solr/cloud/error"

module Blacklight
  module Solr
    module Cloud
      class Repository < Blacklight::Solr::Repository
        include MonitorMixin

        ZNODE_LIVE_NODES = "/live_nodes".freeze
        ZNODE_COLLECTIONS = "/collections".freeze

        def initialize(blacklight_config)
          super(blacklight_config)
          setup_zk
        end

        private def build_connection
          RSolr.connect(connection_config.merge(adapter: connection_config[:http_adapter], url: select_node))
        end

        private

        def setup_zk
          @zk = ZK.new(ENV["ZK_HOST"] || "localhost:2181", {chroot: :do_nothing})
          collection = ENV["SOLR_COLLECTION"] || "blacklight"

          init_collection_state_watcher collection
          init_live_nodes_watcher collection
          update_urls collection
        end

        def init_collection_state_watcher(collection)
          @zk.register(collection_state_znode_path(collection)) do |_event|
            update_collection_state collection
            update_urls collection
          end

          update_collection_state collection
        end

        def collection_state_znode_path(collection)
          "/collections/#{collection}/state.json"
        end

        def update_collection_state(collection)
          synchronize do
            collection_state_json, _stat = @zk.get(collection_state_znode_path(collection), watch: true)
            @collection_state = ::JSON.parse(collection_state_json)[collection]
          end
        end

        def init_live_nodes_watcher(collection)
          @zk.register(ZNODE_LIVE_NODES) do |_event|
            update_live_nodes
            update_urls collection
          end

          update_live_nodes
        end

        def update_urls(collection)
          synchronize do
            @all_urls, @leader_urls = available_urls collection
          end
        end

        def available_urls(collection)
          leader_urls = []
          all_urls = []
          all_nodes.each do |node|
            next unless active_node?(node)
            url = "#{node["base_url"]}/#{collection}"
            leader_urls << url if leader_node? node
            all_urls << url
          end
          [all_urls, leader_urls]
        end

        def all_nodes
          nodes = @collection_state["shards"].values.map do |shard|
            shard["replicas"].values
          end
          nodes.flatten
        end

        def select_node(leader_only = false)
          url = if leader_only
            synchronize do
              @leader_urls.sample
            end
          else
            synchronize do
              @all_urls.sample
            end
          end
          raise Blacklight::Solr::Cloud::NotEnoughNodes unless url
          url
        end

        def update_live_nodes
          synchronize do
            @live_nodes = {}
            @zk.children(ZNODE_LIVE_NODES, watch: true).each do |node|
              @live_nodes[node] = true
            end
          end
        end

        def active_node?(node)
          @live_nodes[node["node_name"]] && node["state"] == "active"
        end

        def leader_node?(node)
          node["leader"] == "true"
        end
      end
    end
  end
end
