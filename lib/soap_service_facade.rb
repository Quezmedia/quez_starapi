Dir[File.dirname(__FILE__) + "/soap_service_facade/*.rb"].each {|file| load file }

module SoapServiceFacade
  NAMESPACE   = "http://www.opsolve.com/RS/webservices/"
  SERVICE_URL = 'http://198.61.141.129/READiDataExchange/WSRSDataExchange.asmx'
  USER        = "WSRS"
  PASSWORD    = "sting"
end
