Dir[File.dirname(__FILE__) + "/soap_service_facade/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/soap_service_facade/#{filename}"
end

module StarApi
  module SoapServiceFacade
  end
end
