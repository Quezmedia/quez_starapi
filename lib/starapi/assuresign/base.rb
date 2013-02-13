
require 'typhoeus'
require 'nokogiri'

module Starapi
  module Assuresign
    class Base
      def construct_envelope(&block)
        Nokogiri::XML::Builder.new do |xml|
          xml.Envelope("xmlns:s" => "http://schemas.xmlsoap.org/soap/envelope/") do
                         xml.parent.namespace = xml.parent.namespace_definitions.first
                         xml['s'].Body("xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                       "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                       &block)
                       end
        end
      end

      def process_response(response)
        Starapi.log.info "Calling Process Response"
        Starapi.log.debug "Response:\n" + response.body
        @last_response = response

        if response.body =~ /s:Fault/ then
          handle_soap_error(response)
        elsif response.body =~ /DocumentException/ then
          handle_api_error(response)
        else
          return response
        end
      end

      def handle_soap_error(response)
        Starapi.log.info "Calling Handle Error"
        xml   = Nokogiri::XML(response.body)
        xpath_code = '/s:Envelope/s:Body/s:Fault//faultcode'
        xpath_string = '/s:Envelope/s:Body/s:Fault//faultstring'
        code  = xml.xpath(xpath_code).text
        msg   = xml.xpath(xpath_string).text

        Starapi.log.info "Error message #{msg}"

        # TODO: Capture any app-specific exception messages here.
        #       For example, if the server returns a Fault when a search
        #       has no results, you might rather return an empty array.

        raise Assuresign::SoapError.new("Error from server: #{code} - #{msg}")
      end

      def handle_api_error(response)
        xml   = Nokogiri::XML(response.body)
        msg   = xml.text

        # TODO: Capture any app-specific exception messages here.
        #       For example, if the server returns a Fault when a search
        #       has no results, you might rather return an empty array.

        raise Assuresign::SoapError.new("Error from server: #{msg}")
      end

    end
  end
end
