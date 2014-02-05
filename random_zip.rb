####################################################
# Janky Zip Code Scraper
#
# To Use:
# in command line type: 'ruby random_zip.rb [state_abbreviation]'
#
# Should return: a random 'ZipCode - CityName' pair
#####################################################

require 'rubygems'
require 'mechanize'
require 'nokogiri'

agent = Mechanize.new
url = 'http://www.zipcodesdirectory.com/'

state_abbrev = ARGV[0].upcase.strip

# Get the hopepage
page = agent.get(url)

# Based on State Abbreviation passed in, click the link to specific state page
state_page = agent.click(page.link_with(:text => /#{state_abbrev}/))

# Return the raw HTML for the state page and parse it with Nokogiri
state_page_html = state_page.parser.to_html
parsed_page = Nokogiri::HTML(state_page_html)

state = parsed_page.css('title').text

zip_city_data = parsed_page.css('tr').map do |row|
  row.xpath('./td').map(&:text)[0,2].join(' - ')
end

# Remove first and last entries from array
zip_city_data = zip_city_data[1..-2]

puts state
puts zip_city_data[rand(0..zip_city_data.length - 1)]

# Profit
