module Starapi
  module Assuresign
    class SoapError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
