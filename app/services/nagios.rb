require 'csv'

class Nagios

  def self.get_sites
    response = HTTParty.get(Rails.application.secrets.nagios_list_url).body
    parsed_response = CSV.parse(response, {:col_sep => "\t"})
    parsed_response.shift
    parsed_response.map{ |site| site.first }
  end

end
