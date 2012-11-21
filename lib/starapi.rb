require 'rails'
require "starapi/version"

module Starapi
  mattr_accessor :namespace
  @@namespace   = "http://www.example.com/RS/webservices/"
  mattr_accessor :service_url
  @@service_url = 'http://example/READiDataExchange/WSRSDataExchange.asmx'
  mattr_accessor :user
  @@user        = "user"
  mattr_accessor :password
  @@password    = "password"

  autoload :SoapServiceFacade, "starapi/soap_service_facade"
  autoload :SoapServiceTarget, "starapi/soap_service_target"

  class << self
    def setup
      yield self
    end
  end


end
