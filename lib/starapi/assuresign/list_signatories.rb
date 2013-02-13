#################### Xml Structure #########################################################
#
# Request Xml ---------------------
#
# POST /Documents/Services/DocumentNOW/v2/DocumentNOW.svc/ListSignatories/text HTTP/1.1
# Host: sb.assuresign.net
# Content-Type: text/xml
# Content-Length: 488
# SOAPAction: https://www.assuresign.net/Services/DocumentNOW/ListSignatories/IListSignatoriesService/ListSignatories
#
# <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
#   <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
#     <ListSignatories xmlns="https://www.assuresign.net/Services/DocumentNOW/ListSignatories">
#       <SignatoryListQuery ContextIdentifier="6c17c44a-458d-455b-b240-fc6dbb8cf1da" Id="19c1a800-42e8-df11-9b14-0022195a8cb4" AuthToken="f4aaf447-8cfa-4701-9951-b4a063653c04" />
#     </ListSignatories>
#   </s:Body>
# </s:Envelope>
#
# Response Xml ---------------------
#
# HTTP/1.1 200 OK
# Content-Type: text/xml
# Content-Length: 673
#
# <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
#   <s:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
#     <ListSignatoriesResponse xmlns="https://www.assuresign.net/Services/DocumentNOW/ListSignatories">
#       <SignatoryListQueryResult Id="19c1a800-42e8-df11-9b14-0022195a8cb4">
#         <Signatories>
#           <SignatoryItem SignatoryId="c7b60b18-43e8-df11-9b14-0022195a8cb4" SignatoryAuthToken="84a5e308-e7ea-49ca-9715-d2a8f5a42667" FirstName="Bob" LastName="Smith" EmailAddress="bsmith@example.com" />
#         </Signatories>
#       </SignatoryListQueryResult>
#     </ListSignatoriesResponse>
#   </s:Body>
# </s:Envelope>

module Starapi
  module Assuresign
    class ListSignatories < Base
      attr_reader :request_xml, :response

      # Envelopes the call to assure sign submit operation
      #
      # @param [Hash] args The arguments hash.
      # @option args [String] :id
      # @option args [String] :auth_token
      def envelope_submit_operation(args={})
        id, auth_token = args[:id], args[:auth_token]

        envelope = construct_envelope do |xml|
          xml.ListSignatories("xmlns" => "https://www.assuresign.net/Services/DocumentNOW/ListSignatories") do
            xml.SignatoryListQuery("ContextIdentifier" => Starapi.assure_context_identifier, "Id" => id, "AuthToken" => auth_token)
          end
        end
      end

      def soap_list_signatories!(args={})
        Starapi.log.info "Calling Soap List Signatories"
        @request_xml = envelope_submit_operation(args).to_xml
        Starapi.log.debug "Request XML:\n" + @request_xml
        @response = Typhoeus::Request.post("https://#{Starapi.assure_host}/Documents/Services/DocumentNOW/v2/DocumentNOW.svc/ListSignatories/text",
                                           :body    => @request_xml,
                                           :headers => {
                                             'Content-Type' => "text/xml; charset=utf-8",
                                             'Host' => Starapi.assure_host,
                                             'SOAPAction'=>  'https://www.assuresign.net/Services/DocumentNOW/ListSignatories/IListSignatoriesService/ListSignatories',
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

        signatories_node = xml.Envelope.Body.ListSignatoriesResponse.SignatoryListQueryResult.Signatories.SignatoryItem

        results = Array.new

        if signatories_node.is_a? Nokogiri::XML::NodeSet
          signatories_node.each do |nd|
            results << parse_signatory_node(nd)
          end
        else
          results << parse_signatory_node(signatories_node)
        end

        results

      end

      def parse_signatory_node(node)
        attrib = node.attributes

        parsed_obj = OpenStruct.new

        parsed_obj.signatory_id = attrib["SignatoryId"].value
        parsed_obj.signatory_auth_token = attrib["SignatoryAuthToken"].value

        parsed_obj
      end

    end
  end
end
