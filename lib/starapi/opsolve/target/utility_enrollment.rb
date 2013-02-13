#################### Xml Structure #########################################################
#
# #### Request ###
#
#  <READiSystem>
#    <proc_type>GU_sp_XN_Enroll_Add</proc_type>
#    <entno>0000</entno>
#    <supno>DUKE_OH</supno>
#    <eu_acct_no>001387895</eu_acct_no>
#    <price_code>DEOR1DEC12</price_code>
#    <campaign_code>WEB</campaign_code>
#    <agent_id>WEB</agent_id>
#    <gu_acct_no></gu_acct_no>
#    <rev_type>R</rev_type>
#    <last_name>Smith</last_name>
#    <first_name>Steve</first_name>
#    <main_phone>3304532439</main_phone>
#    <cell_phone>3304994490</cell_phone>
#    <email>steve.smith@gmail.com</email>
#    <street_addr>4590 Timberline Rd.</street_addr>
#    <street_addr2></street_addr2>
#    <city>Cincinnati</city>
#    <state_abbr>OH</state_abbr>
#    <postal>45215</postal>
#    <eai_trnno>12345</eai_trnno>
#  </READiSystem>
#
#  ### Response ###
#    The stored procedure in READi will return NO error messages if the transaction completed successfully. Failing transactions the READi System error message will be returned.

class Starapi::Opsolve::Target::UtilityEnrollment < Starapi::Opsolve::Target::Base

  @@PROC_TYPE = "GU_sp_XN_Enroll_Add"

  attr_reader :request_xml, :last_response

  # Executes the call to Opsolve Soap Price Quote call
  #
  # @param [Hash] args The arguments hash.
  # @option args [String] entno
  # @option args [String] supno
  # @option args [String] eu_acct_no
  # @option args [String] gu_acct_no
  # @option args [String] rev_type
  # @option args [String] last_name
  # @option args [String] first_name
  # @option args [String] main_phone
  # @option args [String] cell_phone
  # @option args [String] email
  # @option args [String] street_addr
  # @option args [String] street_addr2
  # @option args [String] city
  # @option args [String] state_abbr
  # @option args [String] postal
  # @option args [String] eai_trnno
  # @option args [String] price_code
  def soap_utility_enrollment!(args={})
    Starapi.log.info "Calling Soap Utility Enrollment"

    @entno,             @supno,             @eu_acct_no,        @gu_acct_no,        @rev_type,           @last_name,
      @first_name,        @main_phone,        @cell_phone,        @email,             @street_addr,        @street_addr2,
      @city,              @state_abbr,        @postal,            @eai_trnno,         @price_code,         @campaign_code,
      @agent_id =
      args[:entno],       args[:supno],       args[:eu_acct_no],  args[:gu_acct_no],  args[:rev_type],     args[:last_name],
      args[:first_name],  args[:main_phone],  args[:cell_phone],  args[:email],       args[:street_addr],  args[:street_addr2],
      args[:city],        args[:state_abbr],  args[:postal],      args[:eai_trnno],   args[:price_code],   args[:campaign_code],
      args[:agent_id]


    @request_xml = construct_xml.to_xml
    Starapi.log.debug "Request XML:\n" + @request_xml
    @last_response = get_target_response soap_service_sp.soap_execute_sp_transaction!(@request_xml)
  end

  def parse_response
    if @last_response.blank?
      raise StandardError.new "Response is not loaded. It looks like the request was not made."
    end
    true
  end

  private
  def construct_xml
    Nokogiri::XML::Builder.new do |xml|
      xml.ReadiSystem do
        xml.proc_type     @@PROC_TYPE
        xml.entno         @entno
        xml.supno         @supno
        xml.eu_acct_no    @eu_acct_no
        xml.price_code    @price_code
        xml.campaign_code @campaign_code
        xml.agent_id      @agent_id
        xml.gu_acct_no    @gu_acct_no
        xml.rev_type      @rev_type
        xml.last_name     @last_name
        xml.first_name    @first_name
        xml.main_phone    @main_phone
        xml.cell_phone    @cell_phone
        xml.email         @email
        xml.street_addr   @street_addr
        xml.street_addr2  @street_addr2
        xml.city          @city
        xml.state_abbr    @state_abbr
        xml.postal        @postal
        xml.eai_trnno     @eai_trnno
      end
    end
  end

  def get_target_response(response)
    xml   = Nokogiri::XML(response.body)
    xpath = '/soap:Envelope/soap:Body'
    xml.xpath(xpath).text
  end

end # end class
