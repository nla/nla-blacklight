# frozen_string_literal: true

class UserDetailsFieldComponent < ViewComponent::Base
  def initialize(attribute:, details:, value: nil, editable: true)
    super
    @attribute = attribute
    @details = details
    @label = I18n.t("account.settings.#{attribute}.label")
    @value = value || @details.instance_values[attribute]
    @editable = editable
  end

  def edit_link_text
    I18n.t("account.settings.update.change_text", attribute: I18n.t("account.settings.#{@attribute}.change_text"))
  end
end
