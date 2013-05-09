require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_accessor :raw

      def initialize
        @connection = Escenic::API::Connection.new
        @raw        = Escenic::API::Raw.new :connection => @connection
      end



    end

  end
end