module Escenic
  module API

    class Object < Hashie::Mash
      attr_reader :client

      def initialize(source_hash = nil, default = nil, &blk)
        super
        @client = Escenic::API::Client.new
      end

      def self.init(response)
        instance = self.new(response)
        instance
      end

    end

  end
end