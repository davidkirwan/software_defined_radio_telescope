####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan
# @description  Common Task helper
#
# @date         2013-07-12
####################################################################################################

# Require the tasks
Dir[File.dirname(__FILE__) + "/tasks/*.rb"].each do |file|
  require file
end
