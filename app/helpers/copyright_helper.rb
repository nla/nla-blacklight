module CopyrightHelper
  def rights_contact_us_link
    link_to "Contact us", ENV["COPYRIGHT_CONTACT_URL"]
  end

  def copies_direct_link
    link_to "Copies Direct", "javascript:;", onclick: "document.getElementById('copiesdirect_addcart').submit();".html_safe
  end
end
