#################### Xml Structure #########################################################
#
# #### Request ###
# <READiSystem>
# 	<proc_type>WO_sp_XN_WLOG_Add</proc_type>
# 	<wlog_entno>1004</wlog_entno>
# 	<wlog_wono>1522</wlog_wono>
# 	<wlog_action_code>001</wlog_action_code>
# 	<wlog_entry_date>08/21/1992</wlog_entry_date>
# 	<wlog_duration>1</wlog_duration>
# 	<wlog_invno>1</wlog_invno>
# 	<wlog_metno></wlog_metno>
# 	<wlog_assoc_slnno></wlog_assoc_slnno>
# 	<wlog_slnno></wlog_slnno>
# 	<wlog_source_code></wlog_source_code>
# 	<wlog_read></wlog_read>
# 	<wlog_read_uom></wlog_read_uom>
# 	<wlog_read_date></wlog_read_date>
# 	<wlog_hilo></wlog_hilo>
# 	<wlog_hi></wlog_hi>
# 	<wlog_lo></wlog_lo>
# 	<wlog_test_type></wlog_test_type>
# 	<wlog_test_date></wlog_test_date>
# 	<wlog_test_pressure></wlog_test_pressure>
# 	<wlog_pressure_uom></wlog_pressure_uom>
# 	<wlog_mr_ps_vol></wlog_mr_ps_vol>
# 	<wlog_md_ps_vol></wlog_md_ps_vol>
# 	<wlog_cb_ps_vol></wlog_cb_ps_vol>
# 	<wlog_media></wlog_media>
# 	<wlog_anode></wlog_anode>
# 	<wlog_tested_by></wlog_tested_by>
# 	<wlog_pass></wlog_pass>
# 	<wlog_test_percent></wlog_test_percent>
# 	<wlog_test_read></wlog_test_read>
# 	<wlog_test_temp></wlog_test_temp>
# 	<wlog_tagno></wlog_tagno>
# 	<wlog_comments></wlog_comments>
# 	<wlog_fixed_rate></wlog_fixed_rate>
# 	<wlog_unit_rate></wlog_unit_rate>
# 	<wlog_applnce_code>WTRHT</wlog_applnce_code>
# 	<wlog_action_reason>LEAK</wlog_action_reason>
# 	<eai_trnno>00000</eai_trnno>
# </READiSystem>#
#
#  ### Response ###
#    The stored procedure in READi will return NO error messages if the transaction completed successfully. Failing transactions the READi System error message will be returned.
#    Possible Exceptions:
#    EXCEPTION
#    - Invalid Entity.
#    - Invalid Work Order Number
#    - Invalid Inventory Number
#    - Invalid Meter Number
#    - Invalid Action code

class Starapi::Opsolve::Target::OrderActionLog < Starapi::Opsolve::Target::Base

  @@PROC_TYPE = "WO_sp_XN_WLOG_Add"

  attr_reader :request_xml, :last_response

  # Executes the call to Opsolve Soap Price Quote call
  #
  # @param [Hash] args The arguments hash.
  # option args [String] wlog_entno
  # option args [String] wlog_action_code
  # option args [String] wlog_entry_date
  # option args [String] wlog_comments
  # option args [String] eai_trnno
  def soap_order_action_log!(args={})
    Starapi.log.info "Calling Soap Order Action Log"

    @wlog_entno, @wlog_action_code, @wlog_entry_date,
      @wlog_comments, @eai_trnno =
      args[:wlog_entno], args[:wlog_action_code], args[:wlog_entry_date],
      args[:wlog_comments], args[:eai_trnno]

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
        xml.proc_type           @@PROC_TYPE
        xml.wlog_entno          @wlog_entno
        xml.wlog_action_code    @wlog_action_code
        xml.wlog_entry_date     @wlog_entry_date
        xml.wlog_comments       @wlog_comments
        xml.eai_trnno           @eai_trnno
      end
    end
  end

  def get_target_response(response)
    xml   = Nokogiri::XML(response.body)
    xml.text
  end

end # end class

