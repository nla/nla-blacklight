module Nla
  module Solr
    class Response < Blacklight::Solr::Response
      include Spelling
    end
  end
end
