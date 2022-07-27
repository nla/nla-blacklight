require "zk"

module RSolr
  module Cloud
    class ZkClient < RSolr::Client
      include MonitorMixin

      ZNODE_LIVE_NODES = "/live_nodes".freeze
      ZNODE_COLLECTIONS = "/collections".freeze

      def initialize(connection, options = {})
        super(connection, options)

        setup_zk(@uri)
      end

      def execute(request_context)
        raw_response = begin
          collection_name = request_context[:collection]
          path = request_context[:path].to_s
          url = select_node(collection_name, path == "update")
          response = connection.send(request_context[:method], request_context[:uri].to_s) do |req|
            req.body = request_context[:data] if request_context[:method] == :post and request_context[:data]
            req.headers.merge!(request_context[:headers]) if request_context[:headers]
          end

          {status: response.status.to_i, headers: response.headers, body: response.body.force_encoding("utf-8")}
        rescue Faraday::TimeoutError => e
          raise RSolr::Error::Timeout.new(request_context, e.response)
        rescue Errno::ECONNREFUSED, defined?(Faraday::ConnectionFailed) ? Faraday::ConnectionFailed : Faraday::Error::ConnectionFailed
          raise RSolr::Error::ConnectionRefused, request_context.inspect
        rescue Faraday::Error => e
          raise RSolr::Error::Http.new(request_context, e.response)
        end
        adapt_response(request_context, raw_response) unless raw_response.nil?
      end

      private

      def setup_zk(zk_servers)
        @zk = ZK.new zk_servers
        init_live_nodes_watcher
        init_collections_watcher
      end

      def init_live_nodes_watcher
        @zk.register(ZNODE_LIVE_NODES) do |_event|
          update_live_nodes
          update_urls
        end

        update_live_nodes
      end

      def init_collections_watcher
        @zk.register(ZNODE_COLLECTIONS) do |_event|
          update_collections
          update_urls
        end

        update_collections
      end

      def update_live_nodes
        synchronize do
          @live_nodes = {}
          @zk.children(ZNODE_LIVE_NODES, watch: true).each do |node|
            @live_nodes[node] = true
          end
        end
      end

      def update_collections
        collections = @zk.children(ZNODE_COLLECTIONS, watch: true)
        created = []
        synchronize do
          @collections ||= {}
          deleted = @collections.keys - collections
          created = collections - @collections.keys
          deleted.each { |collection| @collections.delete(collection) }
        end
        created.each { |collection| init_collection_state_watcher(collection) }
      end

      def init_collection_state_watcher(collection)
        @zk.register(collection_state_znode_path(collection)) do
          update_collection_state(collection)
          update_urls
        end

        update_collection_state(collection)
      end

      def collection_state_znode_path(collection)
        "/collections/#{collection}/state.json"
      end

      def update_collection_state(collection)
        synchronize do
          collection_state_json, _stat = @zk.get(collection_state_znode_path(collection), watch: true)
          @collections.merge!(::JSON.parse(collection_state_json))
        end
      end

      def update_urls
        synchronize do
          @all_urls = {}
          @leader_urls = {}
          @collections.each do |name, state|
            @all_urls[name], @leader_urls[name] = available_urls(name, state)
          end
        end
      end

      def available_urls(collection_name, collection_state)
        leader_urls = []
        all_urls = []
        all_nodes(collection_state).each do |node|
          next unless active_node?(node)
          url = "#{node['base_url']}/#{collection_name}"
          leader_urls << url if leader_node?(node)
          all_urls << url
        end
        [all_urls, leader_urls]
      end

      def all_nodes(collection_state)
        nodes = collection_state["shards"].values.map do |shard|
          shard["replicas"].values
        end
        nodes.flatten
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
