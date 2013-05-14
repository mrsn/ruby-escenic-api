require 'escenic-api/client/raw'

module Escenic
  module API

    class Client
      attr_accessor :raw
      attr_reader :base_model, :endpoint

      def initialize
        @base_model = "#{Escenic::API::Config.base_url}/publication/#{Escenic::API::Config.publication}/escenic/model"
        @endpoint = "#{Escenic::API::Config.base_url}/escenic"
        @raw = Escenic::API::Raw.new({}, self)
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