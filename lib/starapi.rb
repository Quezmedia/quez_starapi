require 'rails'
require "starapi/version"
require "starapi/soap_service_facade"
require "starapi/soap_service_target"

module Starapi
  mattr_accessor :namespace
  @@namespace   = "http://www.example.com/RS/webservices/"
  mattr_accessor :service_url
  @@service_url = 'http://example/READiDataExchange/WSRSDataExchange.asmx'
  mattr_accessor :user
  @@user        = "user"
  mattr_accessor :password
  @@password    = "password"

  class << self
    def setup
      yield self
    end
  end


end
