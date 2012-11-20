require "rails/generators"
module Starapi
  module Generators
    class InstallGenerator < Rails::Generatos::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Starapi initializer in your application initializers directory."
      def copy_initializer
        template "starapi.rb", "config/initializers/starapi.rb"
      end

    end # end class
  end #end module
end # end module
