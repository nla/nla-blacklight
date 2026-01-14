# frozen_string_literal: true

class NlaJoin < Blacklight::Rendering::AbstractStep
  def render
    options = config.separator_options || {}

    # rubocop:disable Rails/OutputSafety
    if config[:field] == "title_tsim"
      # For titles, join with <br> to display multiple titles on separate lines
      next_step(values.map { |x| html_escape(x) }.join("<br>").html_safe)
    elsif join? && html? && values.many?
      # Standard BL9 join behavior when join is enabled
      next_step(values.map { |x| html_escape(x) }.to_sentence(options).html_safe)
    else
      # BL9 default: return values as array (no joining)
      next_step(values)
    end
    # rubocop:enable Rails/OutputSafety
  end

  private

  def html_escape(html_text)
    HTMLEntities.new.decode(html_text)
  end

  # @return [Boolean]
  def join?
    options[:join] || config.join || config.separator_options
  end
end
