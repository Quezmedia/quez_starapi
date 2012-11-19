require 'typhoeus'
require 'nokogiri'

module SoapServiceFacade
  class Base
    def construct_envelope(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.Envelope("xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope",
                     "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                     "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema") do
                       xml.parent.namespace = xml.parent.namespace_definitions.first
                       xml['soap12'].Body(&block)
                     end
      end
    end

    def process_response(response)
      @last_response = response

      if response.body =~ /soap:Fault/ then
        handle_error(response)
      else
        return response
      end
    end

    def handle_error(response)
      xml   = Nokogiri::XML(response.body)
      xpath = '/soap:Envelope/soap:Body/soap:Fault//soap:Text'
      msg   = xml.xpath(xpath).text

      # TODO: Capture any app-specific exception messages here.
      #       For example, if the server returns a Fault when a search
      #       has no results, you might rather return an empty array.

      raise SoapServiceFacade::SoapError.new("Error from server: #{msg}")
    end

  end
end
