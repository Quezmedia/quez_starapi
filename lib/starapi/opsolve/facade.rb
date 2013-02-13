module StarApi
  module Opsolve
    module Facade
    end
  end
end

Dir[File.dirname(__FILE__) + "/facade/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/opsolve/facade/#{filename}"
end
