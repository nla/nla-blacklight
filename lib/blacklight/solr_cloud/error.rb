module Blacklight
  module SolrCloud
    class NotEnoughNodes < RuntimeError
      def to_s
        "There are not enough nodes to handle the request."
      end
    end
  end
end
