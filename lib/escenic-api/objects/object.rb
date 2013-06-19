module Escenic
  module API

    class Object
      attr_accessor :content, :raw

      def initialize(content)
        @raw = content
        @content = Hashie::Mash.new(Hash.from_xml(@raw))
      end

      def self.for_id(id)
        raise 'id must not be nil' if id.nil?
        content = call_client_method(:get, {}, {id: id})
        self.new(content)
      end

      def self.perform_create(payload_class, headers, options)
        verify_options(options) if self.respond_to? :verify_options

        call_options = {}
        call_options[:id] = options[:section_id] if options[:section_id]

        options[:verb]      = :create
        payload =  payload_class.new(options)
        call_options[:body] = payload.body

        response = call_client_method(:create, headers, call_options)
        id       = response.header['location'].split('/').last
        self.for_id(id)
      end

      def perform_update(payload_class, object_class, headers, options={})
        options  = options.merge({id: id, verb: :update})
        payload  = payload_class.new(options)
        response = call_client_method(:update, headers, {id: id, body: payload.body})

        if response.instance_of?(Net::HTTPNoContent)
          object_class.for_id(id)
        else
          raise Escenic::API::Error 'update failed'
        end
      end

      def perform_delete(expected_response)
        perform_delete_confirm nil, expected_response
      end

      def perform_delete_confirm(payload_class, expected_response)
        call_options = {id: id}
        client_method = :delete
        unless payload_class.nil?
          options  = {id: id, verb: :delete}
          payload  = payload_class.new(options)
          call_options[:body] = payload.body
          client_method = :delete_confirm
        end
        headers = {}
        response = call_client_method(client_method, headers, call_options)

        if response.instance_of?(expected_response)
          content.each_key do |k|
            content.delete(k.to_sym)
          end
          true
        else
          false
        end
      end

      def id
        @content.entry.identifier
      end

      def resolve_method(method_name)
        self.class.resolve_method(method_name, self.class.name.split('::').last.downcase)
      end

      def self.resolve_method(method_name, class_name)
        "#{method_name}_#{class_name}"
      end

      def call_client_method(method, headers, options)
        method = resolve_method(method)
        Escenic::API::client.endpoints.send(method, headers, options)
      end

      def self.call_client_method(method, headers, options)
        method = self.resolve_method(method, self.name.split('::').last.downcase)
        Escenic::API::client.endpoints.send(method, headers, options)
      end
    end

  end
end