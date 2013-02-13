#################### Xml Structure #########################################################
#
# #### Request ###
#
#  <ReadiSystem>
#    <proc_type>GU_sp_DR_Price_Quote</proc_type>
#    <entno>0000</entno>
#    <supno>DUKE_OH</supno>
#    <rev_type>R</rev_type>
#    <request_date>2012-12-05</request_date>
#  </ReadiSystem>
#
#  ### Response ###
#  <ReadiSystem>
#    <GU_sp_DR_Price_Quote>
#      <entno>0000</entno>
#      <supno>DUKE_OH</locno>
#      <offer_desc>Duke Energy - Ohio - Residential</offer_desc>
#      <rev_type>R</rev_type>
#      <price_desc>Duke Electric Res - 3 Yr - Dec 12</price_desc>
#      <enroll_eff_date>Dec  1 2012 12:00AM</enroll_eff_date>
#      <enroll_exp_date>Dec 31 2012 12:00AM</enroll_exp_date>
#      <offer_price>6.010000000</offer_price>
#      <price_uom>kWh</price_uom>
#      <early_term_type>FIXED</early_term_type>
#      <early_term_amt>50.00</early_term_amt>
#      <price_to_compare>0.120000000</price_compare>
#      <ptc_message>Your price to compare was obtained from the Public Utilities Commission of Ohio (http://www.puco.ohio.gov/puco/index.cfm/industry-information/statistical-reports/ohio-utility-rate-survey/)</ptc_message>
#    </GU_sp_DR_Price_Quote>
#  <ReadiSystem>

class Starapi::Opsolve::Target::PriceQuote < Starapi::Opsolve::Target::Base

  @@PROC_TYPE = "GU_sp_DR_Price_Quote"

  attr_reader :entno, :supno, :rev_type, :request_date, :request_xml, :last_response
  attr_writer :entno, :supno, :rev_type, :request_date

  def soap_price_quote!(args={})
    Starapi.log.info "Calling Soap Price Quote"
    @entno,          @supno,        @rev_type,        @request_date =
      args[:entno],  args[:supno],  args[:rev_type],  args[:request_date]

    @request_xml = construct_xml.to_xml
    Starapi.log.debug "Request XML:\n" + @request_xml
    @last_response = get_target_response soap_service_sp.soap_execute_sp!(@request_xml)
  end

  def parse_response
    if @last_response.blank?
      raise StandardError.new "Response is not loaded. It looks like the request was not made."
    end

    xml = Nokogiri::Slop(@last_response)
    price_quotes_node = xml.document.ReadiSystem.GU_sp_DR_Price_Quote

    results = Array.new

    if price_quotes_node.is_a? Nokogiri::XML::NodeSet
      price_quotes_node.each do |nd|
        results << parse_price_node(nd)
      end
    else
      results << parse_price_node(price_quotes_node)
    end

    results
  end

  private
  def construct_xml
    Nokogiri::XML::Builder.new do |xml|
      xml.ReadiSystem do
        xml.proc_type @@PROC_TYPE
        xml.entno @entno
        xml.supno @supno
        xml.rev_type @rev_type
        xml.request_date @request_date
      end
    end
  end

  def get_target_response(response)
    xml   = Nokogiri::XML(response.body)
    xpath = '/soap:Envelope/soap:Body'
    xml.xpath(xpath).text
  end

  def parse_price_node(node)
    parsed_obj = OpenStruct.new

    parsed_obj.price_code       = node.price_code.content
    parsed_obj.entno            = node.entno.content
    parsed_obj.supno            = node.supno.content
    parsed_obj.offer_desc       = node.offer_desc.content
    parsed_obj.rev_type         = node.rev_type.content
    parsed_obj.price_desc       = node.price_desc.content
    parsed_obj.enroll_eff_date  = node.enroll_eff_date.content
    parsed_obj.enroll_exp_date  = node.enroll_exp_date.content
    parsed_obj.offer_price      = node.offer_price.content
    parsed_obj.price_uom        = node.price_uom.content
    parsed_obj.early_term_type  = node.early_term_type.content
    parsed_obj.early_term_amt   = node.early_term_amt.content
    parsed_obj.price_to_compare = node.price_to_compare.content
    parsed_obj.ptc_message      = node.ptc_message.content

    parsed_obj
  end

end # end class
