# frozen_string_literal: true

class NotesPresenter < Blacklight::FieldPresenter
  include ActionView::Helpers::OutputSafetyHelper
  include ActionView::Helpers::TagHelper

  attr_reader :view_context, :document, :field_config, :except_operations, :options
  delegate :key, :component, to: :field_config

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
            value
          end
        end, "\n")
      end
    else
      values.first
    end

    safe_join(elements, "\n")
  end
end
