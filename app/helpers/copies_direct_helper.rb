module CopiesDirectHelper
  def copies_direct_url(id)
    "#{ENV["COPIES_DIRECT_URL"]}/items/import?source=cat&sourcevalue=#{id}"
  end

  def copies_direct_link(id)
    link_to "Copies Direct", copies_direct_url(id)
  end

  def copies_direct_button(id)
    link_to "Order a copy", copies_direct_url(id), class: "btn btn-primary mb-2 me-2 me-lg-4 px-4"
  end
end
