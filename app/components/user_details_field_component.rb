# frozen_string_literal: true

class UserDetailsFieldComponent < ViewComponent::Base

  def initialize(attribute:, label:, value:)
    super
    @attribute = attribute
    @label = label
    @value = value
  end
end
