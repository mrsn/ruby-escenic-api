module Escenic
  module API

    class Object < Hashie::Mash
      attr_accessor :client

      def self.init(response, client)
        hashish  = Hash.from_xml(response)
        instance = self.new(hashish)
        instance.client = client
        instance
      end

    end

  end
end