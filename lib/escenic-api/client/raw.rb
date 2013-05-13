module Escenic
  module API

    class Raw

      attr_accessor :connection

      def initialize(options = {})
        @connection = options[:connection]
        @endpoint = Escenic::API::Config.endpoint
      end

      def self.add_method(method, action, options = {})
        self.class_eval <<-STR
          def #{options[:as] || action}(options = {})
            request(:#{method}, "#{action}", options)
          end
        STR
      end

      def request(method, action, data = {})
        url = @endpoint + action
        action.sub! ':id', data.delete(:id) if action.match ':id'
        connection.send(method, url)
      end

      add_method :post, '/section', as: 'create_section'
      add_method :get, "/section/:id", as: 'section'
      add_method :get, "/section/:id/subsections", as: 'subsections'

    end

  end
end