###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description Ruby script to handle connections to the Blitzortung cluster for data retrieval.
#
# @usage ruby blitzortung_client.rb
#
# @date 2015-08-03
####################################################################################################

require "time"
require "json"

def minuteband(minute)
  if minute >= 0 and minute < 10
    return "00"
  elsif minute >= 10 and minute < 20
    return "10"
  elsif minute >= 20 and minute < 30
    return "20"
  elsif minute >= 30 and minute < 40
    return "30"
  elsif minute >= 40 and minute < 50
    return "40"
  else
    return "50"
  end
end


def generate_url(time)
  year = time.year
  month = "%02d" % time.month
  day = "%02d" % time.day
  hour = "%02d" % time.hour
  min = "%02d" % minuteband(time.min)

  lightning_url = "http://data.blitzortung.org/Data_1/Protected/Strokes/#{year}/#{month}/#{day}/#{hour}/#{min}.log"
end

time = Time.now.utc
end_time = time + 3600

while time < end_time
  puts time
  puts generate_url(time)
  time += 600
end

=begin
Date
Time
Longitude, Latitude
Unknown
Device identifier I suspect
Stations which were used to generate this datapoint
=end

data_array = Array.new

rawdata = File.readlines("2015-08-03-21-40.log")

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

f = File.open("2015-08-03-21-40.json", "w")
f.write({:blitzortung=>data_array}.to_json)
f.close
