# frozen_string_literal: true

module LayoutHelper
  include Blacklight::LayoutHelperBehavior

  ##
  # Classes used for sizing the main content of a Blacklight page
  # @return [String]
  def main_content_classes
    if display_global_message_on_page?
      "col-md-8 col-lg-9"
    else
      "col-12"
    end
  end

  ##
  # Classes used for sizing the sidebar content of a Blacklight page
  # @return [String]
  def sidebar_classes
    "page-sidebar col-md-4 col-lg-3"
  end
end
