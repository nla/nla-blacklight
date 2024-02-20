module CopyrightStatusHelper
  def rights_contact_us_link(lower: false)
    link_text = lower ? "contact us" : "Contact us"
    link_to link_text, ENV["COPYRIGHT_CONTACT_URL"]
  end
end
