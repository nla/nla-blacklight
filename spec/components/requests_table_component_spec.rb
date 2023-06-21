# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestsTableComponent, type: :component do
  let(:view_context) { controller.view_context }

  it "renders the caption" do
    render_inline(described_class.new([], I18n.t("account.requests.table_headings.ready")))

    expect(page).to have_css("caption", text: I18n.t("account.requests.table_headings.ready"))
  end

  it "renders the table" do
    render_inline(described_class.new([], I18n.t("account.requests.table_headings.ready")))

    expect(page).to have_css("th", text: I18n.t("account.requests.table_column_headings.title"))
    expect(page).to have_css("th", text: I18n.t("account.requests.table_column_headings.location"))
    expect(page).to have_css("th", text: I18n.t("account.requests.table_column_headings.notes"))
    expect(page).to have_css("th", text: I18n.t("account.requests.table_column_headings.request_date"))
  end
end
