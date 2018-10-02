####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan
# @description  DateString Class
#
# @date         2013-07-12
####################################################################################################
# Imports
require 'logger'
require 'date'
require 'time'

class DateString
  def self.now
	now = DateTime.now
    return now.year.to_s + "-" + "%02d" % now.month + "-" + "%02d" % now.day + " " + "%02d" % now.hour + ":" + "%02d" % now.min + ":" + "%02d" % now.sec
  end
end # End of the DateString class
