# frozen_string_literal: true

require "rails_helper"

RSpec.describe FeedbackComponent, type: :component do
  it "renders the error reporting link" do
    render_inline(described_class.new("123"))

    expect(rendered_component).to have_link(I18n.t("feedback.report_error"))
  end
end
