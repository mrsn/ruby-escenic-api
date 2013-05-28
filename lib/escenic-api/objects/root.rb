module Escenic
  module API

    class Root < Escenic::API::Object

      def self.init
        response = self.client.raw.get_root
        self.new(response)
      end

    end

  end
end
