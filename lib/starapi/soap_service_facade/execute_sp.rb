#################### Xml Structure #########################################################
#
#  POST /READiDataExchange/WSRSDataExchange.asmx HTTP/1.1
#  Host: 198.61.141.129
#  Content-Type: application/soap+xml; charset=utf-8
#  Content-Length: length
#
#  <?xml version="1.0" encoding="utf-8"?>
#  <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
#    <soap12:Body>
#      <ExecuteSP xmlns="http://www.opsolve.com/RS/webservices/">
#        <user>string</user>
#        <password>string</password>
#        <spName>string</spName>
#        <paramList>
#          <string>string</string>
#        </paramList>
#        <outputParamList>
#          <string>string</string>
#        </outputParamList>
#        <langCode>string</langCode>
#      </ExecuteSP>
#    </soap12:Body>
#  </soap12:Envelope>

module Starapi
  module SoapServiceFacade
    class ExecuteSP < Base
      attr_reader :request_xml, :response

      def envelope_execute_sp(input_xml)
        envelope = construct_envelope do |xml|
          xml.ExecuteSP("xmlns" => Starapi.namespace) do
            xml.user Starapi.user
            xml.password Starapi.password
            xml.spName "RS_sp_EAI_Output"
            xml.paramList do
              xml.string "input_xml;#{input_xml}"
            end
            xml.outputParamList do
              xml.string "output_xml;8000"
            end
            xml.langCode "en-us"
          end
        end
      end

      def soap_execute_sp!(input_xml)
        @request_xml = envelope_execute_sp(input_xml).to_xml
        @response = Typhoeus::Request.post(Starapi.service_url,
                                           :body    => @request_xml,
                                           :headers => {
                                             'Content-Type' => "text/xml; charset=utf-8",
                                             'Host' => '198.61.141.129',
                                             'SOAPAction'=>  '"http://www.opsolve.com/RS/webservices/ExecuteSP"',
                                             'Content-Length' => @request_xml.length
                                           })
                                           @response = process_response(@response)
      end

    end
  end
end
