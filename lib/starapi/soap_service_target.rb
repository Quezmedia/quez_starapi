Dir[File.dirname(__FILE__) + "/soap_service_target/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/soap_service_target/#{filename}"
end

module StarApi
  module SoapServiceTarget
  end
end
