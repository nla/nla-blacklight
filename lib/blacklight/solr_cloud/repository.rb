require "zk"
require "blacklight/solr_cloud/error"

module Blacklight
  module SolrCloud
    class Repository < Blacklight::Solr::Repository
      include MonitorMixin

      ZNODE_LIVE_NODES = "/live_nodes".freeze

      def initialize(blacklight_config)
        Rails.logger.debug "initializing Blacklight::Solr::Cloud::Repository"
        super(blacklight_config)
        setup_zk
      end

      private def build_connection
        RSolr.connect(connection_config.merge(adapter: connection_config[:http_adapter], url: select_node))
      end

      private

      def setup_zk
        Rails.logger.debug "determining availability of Solr nodes"
        zk = ZK.new(ENV["ZK_HOST"] || "localhost:2181", {chroot: :do_nothing})
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
          all_nodes.each do |node|
            next unless active_node?(node, live_nodes)
            url = "#{node["base_url"]}/#{collection}"
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

      def select_node
        url = synchronize do
          @all_urls.sample
        end
        raise Blacklight::SolrCloud::NotEnoughNodes unless url
        url
      end

      def active_node?(node, live_nodes)
        live_nodes[node["node_name"]] && node["state"] == "active"
      end
    end
  end
end
