require 'typhoeus'
require 'nokogiri'

module Starapi
  module Opsolve
    module Facade
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
          Starapi.log.info "Calling Process Response"
          Starapi.log.debug "Response:\n" + response.body
          @last_response = response

          if response.body =~ /soap:Fault/ then
            handle_error(response)
          else
            return response
          end
        end

        def handle_error(response)
          Starapi.log.info "Calling Handle Error"
          xml   = Nokogiri::XML(response.body)
          xpath = '/soap:Envelope/soap:Body/soap:Fault//soap:Text'
          msg   = xml.xpath(xpath).text

          Starapi.log.info "Error message #{msg}"

          # TODO: Capture any app-specific exception messages here.
          #       For example, if the server returns a Fault when a search
          #       has no results, you might rather return an empty array.

          raise Facade::SoapError.new("Error from server: #{msg}")
        end

      end
    end
  end
end
