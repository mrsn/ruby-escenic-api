module Escenic
  module API

    class Raw

      attr_accessor :connection

      def initialize(options = {})
        @connection = options[:connection]
      end

      def self.add_method(method, action, options = {})
        self.class_eval <<-STR
          def #{options[:as] || action}(options = {})
            request(:#{method}, "#{action}", options)
          end
        STR
      end

      def request(method, action, options = {})
        url = Escenic::API::Config.endpoint + action
        action.sub! ':id', options.delete(:id) if action.match ':id'
        connection.send(method, url, options)
      end

      add_method :get,  '/section/:id', as: 'get_section'
      add_method :post, '/section',     as: 'create_section'
    end

  end
end