# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackComponent, type: :component do
  it "renders the error reporting link" do
    render_inline(described_class.new("123"))

    expect(rendered_content).to have_link(I18n.t("feedback.report_error"))
  end

  it "renders the culturally sensitive item reporting link" do
    render_inline(described_class.new("123"))

    expect(rendered_content).to have_link(I18n.t("feedback.culturally_sensitive"))
  end
end
