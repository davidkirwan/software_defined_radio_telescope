####################################################################################################
# @author       David Kirwan https://github.com/davidkirwan
# @description  Configuration Reader Class
#
# @date         2013-07-12
####################################################################################################
# Imports
require 'yaml'
require 'logger'

module Common
  module Tasks
    
    class ConfigReader
  
      attr_accessor :data, :log;
      
      
      ##
      # Common::Tasks::ConfigReader#load Loads the database from disk
      #
      # * *Args* :
      # - ++ ->   String path, Hash options {Logger :log, Logger::LEVEL :level}
      # * *Returns* :
      # -         Hash data
      # * *Raises* :
      #           ArgumentError
      #
      def self.load(path, options={})
        @log = options[:log] ||= Logger.new(STDOUT)
        @log.level = options[:level] ||= Logger::INFO
          
        begin
          @log.debug "Loading file from #{path}"
          @data = YAML.load(File.open(path))
          @log.debug @data.inspect
            
        rescue ArgumentError => e
          @log.fatal "Could not parse YAML: #{e.message}"
          raise e
        end
          
        return @data  
      end # End of ConfigReader#load
      
      
      ##
      # Common::Tasks::ConfigReader#save Saves the database to disk
      #
      # * *Args* :
      # - ++ ->   Hash newData, String path, Hash options {Logger :log, Logger::LEVEL :level, 
      #                                                     String :mode}
      # * *Returns* :
      # -         
      # * *Raises* :
      #           Exception
      #
      def self.save(newData, path, options={})
        @log = options[:log] ||= Logger.new(STDOUT)
        @log.level = options[:level] ||= Logger::INFO
        @data = newData
        
        begin
          unless options[:mode] == 'append'
            f = File.open(path, 'w')
          else
            f = File.open(path, 'a')
          end
          
          f.write(@data.to_yaml)
          f.close
        rescue Exception => e
          @log.fatal e
          raise e
        end
      end # end of the ConfigReader#save
        

    end # End of ConfigReader Class
    
    
  end
end