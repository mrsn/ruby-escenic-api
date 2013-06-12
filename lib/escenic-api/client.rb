module Escenic
  module API

    class Client
      attr_reader :endpoints

      def initialize
        @endpoints = Escenic::API::Endpoints.new
      end

      def root
        Escenic::API::Root.init
      end
    end

  end
end