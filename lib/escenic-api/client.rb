require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_accessor :raw

      def initialize
        @raw = Escenic::API::Raw.new
      end

      def section(options = {})
        Escenic::API::Section.init(options, self)
      end

      def root_section
        response = self.raw.get_root
        Escenic::API::Object.init(response, self)
      end

    end

  end
end