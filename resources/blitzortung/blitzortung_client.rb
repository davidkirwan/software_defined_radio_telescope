###################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description Ruby script to handle connections to the Blitzortung cluster for data retrieval.
#
# @usage ruby blitzortung_client.rb
#
# @date 2015-08-03
####################################################################################################

require "time"

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
