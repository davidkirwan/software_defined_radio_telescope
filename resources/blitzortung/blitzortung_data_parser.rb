###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description Ruby script to process data logs retrieved from the Blitzortung cluster.
#
# @usage ruby blitzortung_data_parser.rb
#
# @date 2015-08-05
####################################################################################################

require "time"
require "json"

=begin
Date
Time
Longitude, Latitude
Unknown
Device identifier I suspect
Stations which were used to generate this datapoint
=end

data_array = Array.new

rawdata = File.readlines("2015-08-05-00-10.log")

rawdata.each do |i| 
  data = i.split(" ")
  
  date = data[0]
  time = data[1]
  pos_raw = data[2].split(";")
  latitude = pos_raw[1]
  longitude = pos_raw[2]
  elevation = pos_raw[3]
  unknown = data[3]
  device = data[4]
  stations = data[5]

  data_array << {:date=>date, :time=>time, :latitude=>latitude, :longitude=>longitude, :elevation=>elevation, :unknown=>unknown, :device=>device, :stations=>stations}
end

puts data_array.size
puts data_array.first

f = File.open("2015-08-05-00-10.json", "w")
f.write({:blitzortung=>data_array}.to_json)
f.close
