module Starapi
  module SoapServiceFacade
    class SoapError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
