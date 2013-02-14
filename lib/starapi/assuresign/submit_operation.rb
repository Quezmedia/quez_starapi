#################### Xml Structure #########################################################
#
# POST /Documents/Services/DocumentNOW/v2/DocumentNOW.svc/Submit/text HTTP/1.1
# Host: sb.assuresign.net
# Content-Type: text/xml
# Content-Length: 1337
# SOAPAction: https://www.assuresign.net/Services/DocumentNOW/Submit/ISubmitService/Submit
#
# <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
#   <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
#     <Submit xmlns="https://www.assuresign.net/Services/DocumentNOW/Submit">
#       <Documents>
#         <Document ContextIdentifier="6c17c44a-458d-455b-b240-fc6dbb8cf1da">
#           <Metadata UserName="jdoe@example.com" DocumentName="Test Document" OrderNumber="12345" Password="password" ExpirationDate="2013-03-02" Culture="en-US" SignatureDeviceSupportEnabled="true">
#             <TermsAndConditions>
#               <AdditionalComplianceStatement>Additional compliance statement</AdditionalComplianceStatement>
#               <AdditionalAgreementStatement>Additional agreement statement</AdditionalAgreementStatement>
#               <AdditionalExtendedDisclosures>Additional extended disclosures</AdditionalExtendedDisclosures>
#             </TermsAndConditions>
#           </Metadata>
#           <Template Id="98413f47-42e8-df11-9b14-0022195a8cb4">
#             <Parameters>
#               <Parameter Name="Signatory First Name" Value="Bob" />
#               <Parameter Name="Signatory Last Name" Value="Smith" />
#               <Parameter Name="Signatory Email Address" Value="bsmith@example.com" />
#             </Parameters>
#           </Template>
#         </Document>
#       </Documents>
#     </Submit>
#   </s:Body>
# </s:Envelope>

module Starapi
  module Assuresign
    class SubmitOperation < Base
      attr_reader :request_xml, :response

      # Envelopes the call to assure sign submit operation
      #
      # @param [Hash] args The arguments hash.
      # @option args [String] :user_name
      # @option args [String] :document_name
      # @option args [String] :order_number
      # @option args [String] :expiration_date
      # @option args [String] :password
      # @option args [String] :culture
      # @option args [String] :sign_device_support
      # @option args [String] :envelope_id
      # @option args [Hash] :parameters
      # @option args [String] :template_id
      def envelope_submit_operation(args={})
        user_name                  , document_name           , order_number                , expiration_date        ,
          password                 , culture                 , sign_device_support         , envelope_id            ,
          template_id              , parameters =
          args[:user_name]         , args[:document_name]    , args[:order_number]         , args[:expiration_date] ,
          args[:password]          , args[:culture]          , args[:sign_device_support]  , args[:envelope_id]     ,
          args[:template_id]       , args[:parameters]

        envelope = construct_envelope do |xml|
          xml.Submit("xmlns" => "https://www.assuresign.net/Services/DocumentNOW/Submit") do
            xml.Documents do
              xml.Document("ContextIdentifier" => Starapi.assure_context_identifier) do
                xml.Metadata("UserName"                      => user_name,
                             "DocumentName"                  => document_name,
                             "OrderNumber"                   => order_number,
                             "ExpirationDate"                => expiration_date,
                             "Password"                      => password,
                             "Culture"                       => culture,
                             "SignatureDeviceSupportEnabled" => sign_device_support) do
                               xml.TermsAndConditions do
                                 xml.AdditionalComplianceStatement " AdditionalComplianceStatement "
                                 xml.AdditionalAgreementStatement " AdditionalAgreementStatement "
                                 xml.AdditionalExtendedDisclosures "AdditionalExtendedDisclosures  "
                               end
                             end
                             xml.Template("Id" => template_id) do
                               xml.Parameters do
                                 parameters.each do |key, value|
                                  xml.Parameter("Name" => key, "Value" => value)
                                 end
                               end
                             end
              end
            end
          end
        end
      end

      def soap_submit_operation!(args={})
        Starapi.log.info "Calling Soap Submit Operation"
        @request_xml = envelope_submit_operation(args).to_xml
        Starapi.log.debug "Request XML:\n" + @request_xml
        @response = Typhoeus::Request.post("#{Starapi.assure_base_url}/Services/DocumentNOW/v2/DocumentNOW.svc/Submit/text",
                                           :body    => @request_xml,
                                           :headers => {
                                             'Content-Type' => "text/xml; charset=utf-8",
                                             'Host' => Starapi.assure_host,
                                             'SOAPAction'=>  'https://www.assuresign.net/Services/DocumentNOW/Submit/ISubmitService/Submit',
                                             'Content-Length' => @request_xml.length
                                           })
                                           @response = process_response(@response)
                                           Starapi.log.debug "Response XML:\n" + @response.body
                                           @response
      end

      def parse_response
        if @response.body.blank?
          raise StandardError.new "Response is not loaded. It looks like the request was not made."
        end

        xml = Nokogiri::Slop(@response.body)
        xml.remove_namespaces!

        parsed_obj = OpenStruct.new

        attrib = xml.Envelope.Body.SubmitResponse.DocumentResults.DocumentResult.attributes
        parsed_obj.id = attrib["Id"].value
        parsed_obj.auth_token = attrib["AuthToken"].value

        parsed_obj
      end

    end
  end
end
