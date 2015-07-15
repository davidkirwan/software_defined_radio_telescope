####################################################################################################
# @author: David Kirwan https://github.com/davidkirwan
# @description: Ruby script to generate countries.yaml
#
# @usage: ruby countries_parser.rb
#
# @uri: 
#   - http://www.dxing.com/callsign.htm
#   - http://www.dxing.com/CallSign.pdf
#
# @date 2015-07-11
####################################################################################################

require "yaml"

country_lines = File.readlines("countries.txt")

country_hash = Hash.new
country_lines.map do |i|
  i = i.delete("\n").downcase
  x = i.split(":")
  k = x[1].gsub(/[^0-9a-z]/i, '_')
  k = k.gsub(/_+/, '_')
  v = x[0].split("-")
  if country_hash[k].nil? then country_hash[k] = Array.new; country_hash[k] << v; else country_hash[k] << v; end
end

File.open("countries.yaml", "w").write(country_hash.to_yaml)
