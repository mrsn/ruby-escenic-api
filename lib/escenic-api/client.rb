require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_accessor :raw

      def initialize
        @connection = Escenic::API::Connection.new
        @raw        = Escenic::API::Raw.new :connection => @connection
      end

      def section(action, options = {})
        case action
          when :create
            response = raw.create_section(options)
            Escenic::API::Section.init(response, self)
          when :get
            puts options
            Escenic::API::Section.init(self.raw.section(options), self)
          else
            raise "Action not defined: #{action}"
        end

      end

    end

  end
end