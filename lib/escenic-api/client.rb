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

      def root
        Escenic::API::Root.init
      end
    end

  end
end