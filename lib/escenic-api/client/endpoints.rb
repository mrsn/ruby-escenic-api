module Escenic
  module API

    class Endpoints
      attr_reader :connection

      def initialize
        @connection = Escenic::API::Connection.new
      end

      def self.add_method(method, action, method_config = {})
        self.class_eval <<-STR
          def #{method_config[:as] || action}(headers = {}, options = {})
            request(:#{method}, "#{action}", headers, options)
          end
        STR
      end

      def request(method, action, headers, options = {})
        action.sub! ':id', options.delete(:id).to_s if action.match ':id'

        case options[:endpoint_type]
          when :binary
            url = Escenic::API::Config.endpoint_binary + action
          else
            url = Escenic::API::Config.endpoint + action
        end
        connection.send(method, url, headers, options)
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

      # binary
      add_method :post,     '/binary/:id',                as: 'create_binary' # id means object type, e.g. picture

      # picture
      # binary sub-types don't have post, it's handled by the binary upload endpoint.
      add_method :get,      '/content/:id',               as: 'get_picture'
      add_method :put,      '/content/:id',               as: 'update_picture'
      add_method :delete,   '/content/:id',               as: 'delete_picture'

    end

  end
end