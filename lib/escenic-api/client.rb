require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_reader :raw

      def initialize
        Escenic::API::Config.base_model = Escenic::API::Config.base_url     + '/publication/'   +
                                          Escenic::API::Config.publication  + '/escenic/model'
        Escenic::API::Config.endpoint   = Escenic::API::Config.base_url     + '/escenic'
        @raw = Escenic::API::Raw.new
      end

      def section(options = {})
        Escenic::API::Section.init(options)
      end

      def root_section
        response = raw.get_root
        Escenic::API::Object.init(response)
      end

    end

  end
end