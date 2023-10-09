# frozen_string_literal: true

require "singleton"

class MarcDerivedField
  include Singleton

  def initialize
    @mutex = Mutex.new
  end

  # Get data from the full marc record contained in the solr document using a Traject spec.
  def derive(marc_rec, spec, options = {})
    @mutex.synchronize do
      data = Traject::MarcExtractor.cached(spec, options).extract(marc_rec)
      data.presence
    end
  end
end
