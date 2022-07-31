module Blacklight
  module Solr
    module Cloud
      class NotEnoughNodes < RuntimeError
        def to_s
          "There are not enough nodes to handle the request."
        end
      end
    end
  end
end
