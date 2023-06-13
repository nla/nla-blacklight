module Nla
  module Citations
    extend ActiveSupport::Concern

    def export_as_harvard_citation_txt
      HarvardCitationService.new(self).cite
    end

    def export_as_wikipedia_citation_txt
      citation = 'Please see <a href="https://en.wikipedia.org/wiki/Template:Citation">Wikipedia\'s template documentation</a> for further citation fields that may be required.'
      citation + WikimediaCitationService.new(self).cite
    end
  end
end
