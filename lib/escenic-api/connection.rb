require 'escenic-api/connection/requests'

module Escenic
  module API

    class Connection
      include Escenic::API::Connection::Requests

      def initialize()
        raise Escenic::API::Error if
            Escenic::API::Config.user.nil? ||
                Escenic::API::Config.pass.nil? ||
                Escenic::API::Config.endpoint.nil?
        @user     = Escenic::API::Config.user
        @pass     = Escenic::API::Config.pass
        @endpoint = Escenic::API::Config.endpoint
      end

    end

  end
end