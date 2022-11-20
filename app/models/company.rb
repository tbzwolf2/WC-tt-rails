class Company < ApplicationRecord

  #Simple method to use gov api with auth
  def self.get_gov_api(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req.basic_auth ENV['GOV_API_KEY'], ''

    req_options = {
      use_ssl: uri.scheme == "https"
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    res.body
  end
end
