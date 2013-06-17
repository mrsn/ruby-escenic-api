module Escenic
  module API

    class Endpoints
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

      # section
      add_method :post,     '/section',                   as: 'create_section'
      add_method :get,      '/section/:id',               as: 'get_section'
      add_method :put,      '/section/:id',               as: 'update_section'
      add_method :delete,   '/section/:id',               as: 'delete_section'
      add_method :put,      '/section/:id/delete',        as: 'delete_confirm_section'

      # ???
      add_method :get,      '/section/:id/subsections',   as: 'get_subsections'

      # root
      add_method :get,      '/section/ROOT/subsections',  as: 'get_root'

      # content item
      add_method :post,     '/section/:id/content-items', as: 'create_contentitem'
      add_method :get,      '/content/:id',               as: 'get_contentitem'
      add_method :put,      '/content/:id',               as: 'update_contentitem'
      add_method :delete,   '/content/:id',               as: 'delete_contentitem'

      # person
      add_method :post,     '/person',                    as: 'create_person'
      add_method :get,      '/person/:id',                as: 'get_person'
      add_method :put,      '/person/:id',                as: 'update_person'
      add_method :delete,   '/person/:id',                as: 'delete_person'

      # spec
      add_method :get,      '/model/:id',                 as: 'get_spec'
    end

  end
end