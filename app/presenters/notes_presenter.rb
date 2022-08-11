# frozen_string_literal: true

class NotesPresenter < Blacklight::FieldPresenter
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper

  attr_reader :view_context, :document, :field_config, :except_operations, :options
  delegate :key, :component, to: :field_config

  # Original RegEx used by VuFind
  URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=+$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=+$,\w]+@)[A-Za-z0-9.-]+)((?:\/[+~%\/.[A-Za-z0-9_]-_]*)?\??(?:[-+=&;%@.\w_]*)#?(?:[\w\/.]*))?)/

  def render
    elements = []

    notes_hash = values.first

    # notes
    elements << build_list(notes_hash[:notes])

    # more_notes
    elements << build_list(notes_hash[:more_notes])

    safe_join(elements, "\n")
  end

  private

  def build_list(values)
    elements = []

    elements << if values.size > 1
      view_context.content_tag(:ul) do
        safe_join(values.map do |value|
          view_context.content_tag(:li) do
            link_urls(value)
          end
        end, "\n")
      end
    else
      values.first
    end

    safe_join(elements, "\n")
  end

  def link_urls(value)
    result = value

    unless value.empty?
      # rubocop:disable Rails/OutputSafety
      result = value.gsub(URI::DEFAULT_PARSER.make_regexp(%w[http https]), '<a href="\0">\0</a>').html_safe
      # rubocop:enable Rails/OutputSafety
    end

    result
  end
end
