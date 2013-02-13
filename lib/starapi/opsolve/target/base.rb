module Starapi
  module Opsolve
    module Target
      class Base
        attr_reader :soap_execute_sp

        def soap_service_sp
          @soap_execute_sp ||= Facade::ExecuteSP.new
        end
      end
    end
  end
end
