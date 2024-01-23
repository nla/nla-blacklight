class NlaJoin < Blacklight::Rendering::AbstractStep
  def render
    # :nocov:
    options = config.separator_options || {}
    # :nocov:
    # rubocop:disable Rails/OutputSafety
    if config[:field] == "title_tsim"
      next_step(values.map { |x| html_escape(x) }.join("<br>").html_safe)
    else
      # :nocov:
      next_step(values.map { |x| html_escape(x) }.to_sentence(options).html_safe)
      # :nocov:
    end
    # rubocop:enable Rails/OutputSafety
  end

  private

  # :nocov:
  def html_escape(html_text)
    HTMLEntities.new.decode(html_text)
  end
  # :nocov:
end
