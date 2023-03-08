class StaffOnlyConstraint
  def initialize
    @ips = ENV["STAFF_SUBNET"].split(",")
  end

  def matches?(request)
    Rails.env.development? || in_subnet?(request)
  end

  protected

  def in_subnet?(request)
    client_ip = get_client_ip(request)

    client_ranges = client_ip.split(".")
    subnet_ranges = @ips.split(".")

    match = false
    4.times { |i|
      if subnet_ranges[i] == "0" || client_ranges[i] == subnet_ranges[i]
        match = true
      else
        return false
      end
    }

    match
  end

  def get_client_ip(request)
    client_ip = request.remote_ip

    if client_ip.include? ","
      client_ip = client_ip.split(",")
      client_ip = client_ip.last
    end

    client_ip
  end
end
