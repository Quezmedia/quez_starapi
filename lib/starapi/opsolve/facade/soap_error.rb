class Starapi::Opsolve::Facade::SoapError < StandardError
  def initialize(message)
    super(message)
  end
end
