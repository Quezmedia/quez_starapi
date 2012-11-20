module Starapi
  module SoapServiceTarget
  class Base
    attr_reader :soap_execute_sp

    def soap_service_sp
      @soap_execute_sp ||= SoapServiceFacade::ExecuteSP.new
    end
  end
end
end
