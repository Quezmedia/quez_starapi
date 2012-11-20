#################### Xml Structure #########################################################
#
# #### Request ###
#
#  <ReadiSystem>
#    <proc_type>GU_sp_DR_Price_Quote</proc_type>
#    <entno>7827</entno>
#    <supno>DUKE_OH</supno>
#    <rev_type>R</rev_type>
#    <request_date>2012-12-05</request_date>
#  </ReadiSystem>
#
#  ### Response ###
#	<READiSystem>
#		<GU_sp_DR_FF_Quote>
#			<entno>0001</entno>
#			<supno>FE_OHED</supno>
#			<offer_desc>Ohio Electric - Residential</offer_desc>
#			<rev_type>R</rev_type>
#			<price_desc>Ohio Res - 1 Yr Fixed - Dec 12</price_desc>
#			<enroll_eff_date>2012-12-01</enroll_eff_date>
#			<enroll_exp_date>2012-12-31</enroll_exp_date>
#			<offer_price>0.0965</offer_price >
#			<price_uom>kWh</price_uom>
#			<price_to_compare >0.0984</price_to_compare>
#			<ptc_message>The Price to Compare for Ohio Electric was derived assuming a 750kWh average monthly consumption.  Your actual Price to Compare could vary slightly based on your actual usage.</ptc_message>
#		</GU_sp_DR_FF_Quote>
#	</READiSystem>

module Starapi
  module SoapServiceTarget
    class PriceQuote < Base

      @@PROC_TYPE = "GU_sp_DR_Price_Quote"

      attr_reader :entno, :supno, :rev_type, :request_date, :request_xml, :last_response
      attr_writer :entno, :supno, :rev_type, :request_date

      def initialize(entno, supno, rev_type, request_date)
        @entno, @supno, @rev_type, @request_date = entno, supno, rev_type, request_date
      end

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

      def soap_price_quote!
        @request_xml = construct_xml.to_xml
        @last_response = get_target_response soap_service_sp.soap_execute_sp!(@request_xml)
      end

      def parse_response
        if @last_response.blank?
          raise StandardError.new "Response is not loaded. It looks like the request was not made."
        end

        xml = Nokogiri::XML(@last_response)

        parsed_obj = OpenStruct.new

        parsed_obj.entno            = xml.xpath("//entno").text
        parsed_obj.supno            = xml.xpath("//supno").text
        parsed_obj.offer_desc       = xml.xpath("//offer_desc").text
        parsed_obj.rev_type         = xml.xpath("//rev_type").text
        parsed_obj.price_desc       = xml.xpath("//price_desc").text
        parsed_obj.enroll_eff_date  = xml.xpath("//enroll_eff_date").text
        parsed_obj.enroll_exp_date  = xml.xpath("//enroll_exp_date").text
        parsed_obj.offer_price      = xml.xpath("//offer_price").text
        parsed_obj.price_uom        = xml.xpath("//price_uom").text
        parsed_obj.price_to_compare = xml.xpath("//price_to_compare").text
        parsed_obj.ptc_message      = xml.xpath("//ptc_message").text
        parsed_obj
      end

      private
      def get_target_response(response)
        xml   = Nokogiri::XML(response.body)
        xpath = '/soap:Envelope/soap:Body'
        xml.xpath(xpath).text
      end

    end # end class
  end # end module
end #end module
