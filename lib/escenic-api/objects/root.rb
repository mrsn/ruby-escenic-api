module Escenic
  module API

    class Root < Escenic::API::Object
      def self.init
        response = Escenic::API::client.raw.get_root
        self.new(response)
      end

    end

  end
end
