require "zk"
require "blacklight/solr/cloud/error"

module Blacklight
  module Solr
    module Cloud
      class Repository < Blacklight::Solr::Repository
        include MonitorMixin

        ZNODE_LIVE_NODES = "/live_nodes".freeze

        def initialize(blacklight_config)
          Rails.logger.info "initializing Blacklight::Solr::Cloud::Repository"
          super(blacklight_config)
          setup_zk
        end

        private def build_connection
          RSolr.connect(connection_config.merge(adapter: connection_config[:http_adapter], url: select_node))
        end

        private

        def setup_zk
          Rails.logger.info "initializing Zookeeper"
          zk ||= ZK.new(ENV["ZK_HOST"] || "localhost:2181", {chroot: :do_nothing})
          collection = ENV["SOLR_COLLECTION"] || "blacklight"

          collection_state = get_collection_state(collection, zk)
          all_nodes = get_all_nodes(collection_state)
          live_nodes = get_live_nodes zk
          update_urls(collection, all_nodes, live_nodes)
        end

        def collection_state_znode_path(collection)
          "/collections/#{collection}/state.json"
        end

        def get_collection_state(collection, zk)
          synchronize do
            collection_state_json, _stat = zk.get(collection_state_znode_path(collection), watch: false)
            ::JSON.parse(collection_state_json)[collection]
          end
        end

        def get_live_nodes(zk)
          synchronize do
            live_nodes = {}
            zk.children(ZNODE_LIVE_NODES, watch: false).each do |node|
              live_nodes[node] = true
            end

            live_nodes
          end
        end

        def update_urls(collection, all_nodes, live_nodes)
          synchronize do
            @all_urls = []
            @leader_urls = []
            all_nodes.each do |node|
              next unless active_node?(node, live_nodes)
              url = "#{node["base_url"]}/#{collection}"
              @leader_urls << url if leader_node? node
              @all_urls << url
            end
          end
        end

        def get_all_nodes(collection_state)
          nodes = collection_state["shards"].values.map do |shard|
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

        def active_node?(node, live_nodes)
          live_nodes[node["node_name"]] && node["state"] == "active"
        end

        def leader_node?(node)
          node["leader"] == "true"
        end
      end
    end
  end
end
