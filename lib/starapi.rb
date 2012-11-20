require "starapi/version"
require "starapi/soap_service_facade"
require "starapi/soap_service_target"

module Starapi
  mattr_accessor :namespace
  @@namespace   = "http://www.opsolve.com/RS/webservices/"
  mattr_accessor :service_url
  @@service_url = 'http://198.61.141.129/READiDataExchange/WSRSDataExchange.asmx'
  mattr_accessor :user
  @@user        = "WSRS"
  mattr_accessor :password
  @@password    = "sting"

  class << self
    def setup
      yield self
    end
  end


end
