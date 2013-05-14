require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_accessor :raw

      def initialize
        @connection = Escenic::API::Connection.new
        @raw        = Escenic::API::Raw.new :connection => @connection
      end

      def section(options = {})
        if options[:id].nil?
          options[:name].nil? raise Escenic::API::Error('Section name required')
          options[:unique_name].nil? raise Escenic::API::Error('Unique name required')
          options[:directory].nil? raise Escenic::API::Error('Directory name required')

        else
          response = self.raw.get_section(id: options[:id])
          Escenic::API::Section.init(response, self)
        end
      end

    end

  end
end