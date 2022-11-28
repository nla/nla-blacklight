# frozen_string_literal: true

module Nla::Solr::Response::Spelling
  extend Blacklight::Solr::Response::Spelling

  EXCLUDED_TERMS = %w[dismax edismax lucene]

  def spelling
    @spelling ||= Base.new(self)
  end

  class Base < Blacklight::Solr::Response::Spelling::Base
    # returns an array of spelling suggestion for specific query words,
    # as provided in the solr response.  Only includes words with higher
    # frequency of occurrence than word in original query.
    # can't do a full query suggestion because we only get info for each word;
    # combination of words may not have results.
    # Thanks to Naomi Dushay!
    def words
      @words ||= begin
        word_suggestions = []
        spellcheck = response[:spellcheck]
        if spellcheck && spellcheck[:suggestions]
          suggestions = spellcheck[:suggestions]
          unless suggestions.nil?
            if suggestions.is_a?(Array)
              # Before solr 6.5 suggestions is an array with the following format:
              #    (query term)
              #    (hash of term info and term suggestion)
              #    ...
              #    (query term)
              #    (hash of term info and term suggestion)
              #    'correctlySpelled'
              #    true/false
              #    collation
              #    (suggestion for collation)
              # We turn it into a hash here so that it is the same format as in solr 6.5 and later
              suggestions = Hash[*suggestions].except("correctlySpelled", "collation")
            end

            # Exclude the defType term in case this is an advanced search query
            suggestions = suggestions.except(*EXCLUDED_TERMS)

            suggestions.each_value do |term_info|
              # term_info is a hash:
              #   numFound =>
              #   startOffset =>
              #   endOffset =>
              #   origFreq =>
              #   suggestion =>  [{ frequency =>, word => }] # for extended results
              #   suggestion => ['word'] # for non-extended results
              orig_freq = term_info["origFreq"]
              word_suggestions << if term_info["suggestion"].first.is_a?(Hash)
                term_info["suggestion"].map do |suggestion|
                  suggestion["word"] if suggestion["freq"] > orig_freq
                end
              else
                # only extended suggestions have frequency so we just return all suggestions
                term_info["suggestion"]
              end
            end
          end
        end
        word_suggestions.flatten.compact.uniq
      end
    end
  end
end
