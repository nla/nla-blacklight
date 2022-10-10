module CopyrightHelper
  def fair_dealing_link
    link_to "fair dealing", ENV["COPYRIGHT_FAIR_DEALING_URL"]
  end

  def rights_contact_us_link
    link_to "Contact us", ENV["COPYRIGHT_CONTACT_URL"]
  end

  def copies_direct_link
    link_to "Copies Direct", "javascript:;", onclick: "document.getElementById('copiesdirect_addcart').submit();".html_safe
  end
end
