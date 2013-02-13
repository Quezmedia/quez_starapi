require 'spec_helper'

describe Starapi do
  before do
    Starapi.setup do |config|
      # Opsolve infos
      config.namespace   = "http://www.opsolve.com/RS/webservices/"
      config.service_url = 'http://198.61.141.129/READiDataExchange/WSRSDataExchange.asmx'
      config.user        = "WSRS"
      config.password    = "sting"

      # Assuresign infos
      config.assure_context_identifier = "40bd94f8-4507-493d-b6e7-7c85a4c6eec8"
    end
  end

  it "should have version defined" do
    Starapi::VERSION.should_not be_nil
  end

  it "should get prices" do
    soap_service = Starapi::Opsolve::Target::PriceQuote.new
    result = soap_service.soap_price_quote!(:entno => "7827",
                                            :supno => "DUKE_OH",
                                            :rev_type => "R",
                                            :request_date => Time.now.strftime("%Y-%m-%d")
                                           )
                                           result.should_not be_blank
  end

  it "should send order action log" do
    soap = Starapi::Opsolve::Target::OrderActionLog.new
    response = soap.soap_order_action_log!(:wlog_entno => '7827',
    :wlog_action_code => 'approved',
    :wlog_entry_date => '2013-01-21',
    :wlog_comments => 'It is a testing call',
    :wlog_wono => '123455',
    :eai_trnno => '7827')
    results = soap.parse_response


  end
end
