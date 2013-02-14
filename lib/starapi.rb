require 'rails'
require "starapi/version"
require 'logging'

module Starapi
  # Configurable informations
  mattr_accessor :namespace
  @@namespace   = "http://www.example.com/RS/webservices/"
  mattr_accessor :service_url
  @@service_url = 'http://www.example.com/READiDataExchange/WSRSDataExchange.asmx'
  mattr_accessor :user
  @@user        = "user"
  mattr_accessor :password
  @@password    = "password"

  mattr_accessor :assure_context_identifier
  @@assure_context_identifier    = "XXXXXXXXXXXXXXXXXXX"

  mattr_accessor :assure_base_url
  @@assure_base_url = "https://xx.assuresign.net/XXX/XXX/vs/XXX.svc"

  mattr_accessor :assure_host
  @@assure_host     = "xx.assuresign.net"

  mattr_accessor :assure_template_id
  @@assure_template_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  # Log system
  Logging.init :debug, :info, :warn, :error, :fatal
  layout = Logging::Layouts::Pattern.new :pattern => "[%d] [%-5l] %m\n"
  default_appender = Logging::Appenders::RollingFile.new 'default',
    :filename => "log/starapi.log", :age => 'daily', :keep => 30, :safe => true, :layout => layout

  mattr_accessor :log
  @@log = Logging::Logger[:root]
  @@log.add_appenders default_appender
  @@log.level = :debug

  # Load the dependencies
  autoload :Opsolve, "starapi/opsolve"
  autoload :Assuresign, "starapi/assuresign"

  # To permit Rails style config initalizer
  class << self
    def setup
      yield self
    end
  end
end
