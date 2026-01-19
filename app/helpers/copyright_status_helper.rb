module CopyrightStatusHelper
  def rights_contact_us_link(lower: false)

    link_text = lower ? "contact us" : "Contact us"
    link_to link_text, ENV["COPYRIGHT_CONTACT_URL"]
  end

  def rights_enquiry_url(item_title:, item_primary_contributor:, user_first_name:, user_last_name:)
    base_url = "https://reftracker.nla.gov.au/reft100.aspx"
    params = {
      key: "Rights_Enquiry",
      bbttl: item_title,
      bbaut: item_primary_contributor,
      clname: user_first_name,
      clsname: user_last_name
    }
    "#{base_url}?#{params.to_query}"
  end

  def rights_enquiry_link(document:, lower: false)
    link_text = lower ? "contact us" : "Contact us"
    url = rights_enquiry_url(
      item_title: document.first("title_tsim").to_s,
      item_primary_contributor: document.first("author_ssm").to_s,
      user_first_name: current_user&.first_name.to_s,
      user_last_name: current_user&.last_name.to_s
    )
    link_to link_text, url
  end

  def error_feedback_url2(id)
    url = ENV.fetch("COPYRIGHT_CONTACT_URL", "#")
    if url != "#"
      "#{url}&qnudftb17=#{request.original_url}&qnudftb11=#{id}"
    else
      url
    end
  end
end
