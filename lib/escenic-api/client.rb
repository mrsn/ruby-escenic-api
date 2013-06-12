module Escenic
  module API

    class Client
      attr_reader :raw

      def initialize
        @raw = Escenic::API::Raw.new
      end

      def root
        Escenic::API::Root.init
      end
    end

  end
end