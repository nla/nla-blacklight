module Nla
  module Citations
    extend ActiveSupport::Concern

    def export_as_nla_apa_citation_txt
      ApaCitationService.cite(self)
    end

    def export_as_nla_mla_citation_txt
      MlaCitationService.cite(self)
    end

    def export_as_nla_harvard_citation_txt
      HarvardCitationService.cite(self)
    end

    def export_as_nla_wikipedia_citation_txt
      WikimediaCitationService.cite(self)
    end
  end
end
