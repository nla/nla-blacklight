module CopyrightStatusHelper
  def rights_contact_us_link(lower: false)

    link_text = lower ? "contact us" : "Contact us"
    link_to link_text, ENV["COPYRIGHT_CONTACT_URL"]
  end

  def rights_enquiry_url(item_title:, item_primary_contributor:, user_name:, last_accessed_url:)
    base_url = "https://reftracker.nla.gov.au/reft100.aspx"
    params = {
      key: "Rights_Enquiry",
      bbttl: item_title,
      bbaut: item_primary_contributor,
      clname: user_name,
      qnudftb17: last_accessed_url
    }
    "#{base_url}?#{params.to_query}"
  end

  def rights_enquiry_link(document:, lower: false)
    link_text = lower ? "contact us" : "Contact us"

    url = rights_enquiry_url(
      item_title: document.first("title_tsim").to_s,
      item_primary_contributor: document.first("author_ssm").to_s,
      user_name: "#{current_user&.name_given} #{current_user&.name_family}".strip,
      last_accessed_url: request.original_url
    )
    link_to link_text, url
  end
end
