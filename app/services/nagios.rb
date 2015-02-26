require 'csv'

class Nagios

  def self.get_sites
    response = HTTParty.get("https://raw.githubusercontent.com/strtwtsn/strtwtsn.github.io/master/data.tsv").body
    parsed_response = CSV.parse(response, {:col_sep => "\t"})
    parsed_response.shift
    parsed_response.map{ |site| site.first }
  end

end