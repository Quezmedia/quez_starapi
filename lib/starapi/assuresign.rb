Dir[File.dirname(__FILE__) + "/assuresign/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/assuresign/#{filename}"
end

module StarApi
  module Assuresign
  end
end
