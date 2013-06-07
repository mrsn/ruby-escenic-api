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

      def root
        Escenic::API::Root.init
      end

      def content_item(options = {})
        Escenic::API::ContentItem.init(options)
      end

    end

  end
end