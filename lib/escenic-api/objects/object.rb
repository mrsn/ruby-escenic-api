module Escenic
  module API

    class Object < Hashie::Mash
      attr_accessor :client

      def self.init(response, client)
        instance = self.new(response)
        instance.client = client
        instance
      end

    end

  end
end