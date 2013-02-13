module StarApi
  module Opsolve
    module Target
    end
  end
end

Dir[File.dirname(__FILE__) + "/target/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "starapi/opsolve/target/#{filename}"
end
