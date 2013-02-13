Dir[File.dirname(__FILE__) + "/opsolve/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/opsolve/#{filename}"
end

module StarApi
  module Opsolve
  end
end
