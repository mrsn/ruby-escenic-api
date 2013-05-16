module Escenic
  module API

    class Raw
      attr_reader :connection

      def initialize
        @connection = Escenic::API::Connection.new
      end

      def self.add_method(method, action, options = {})
        self.class_eval <<-STR
          def #{options[:as] || action}(options = {})
            request(:#{method}, "#{action}", options)
          end
        STR
      end

      def request(method, action, options = {})
        action.sub! ':id', options.delete(:id).to_s if action.match ':id'
        url = Escenic::API::Config.endpoint + action
        connection.send(method, url, options)
      end

      add_method :post,   '/section',                   as: 'create_section'
      add_method :delete, '/section/:id',               as: 'delete_section'
      add_method :get,    '/section/:id',               as: 'get_section'
      add_method :put,    '/section/:id/delete',        as: 'confirm_delete'
      add_method :get,    '/section/ROOT/subsections',  as: 'get_root'
    end

  end
end