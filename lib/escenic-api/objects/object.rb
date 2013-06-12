module Escenic
  module API

    class Object
      attr_accessor :content

      def initialize(content)
        @content = Hashie::Mash.new(content)
      end

      def self.for_id(id)
        raise 'id must not be nil' if id.nil?
        response = call_client_method(:get, {id: id})
        self.new(response)
      end

      def self.perform_create(payload_class, options)
        verify_options(options) if self.respond_to? :verify_options

        section_id = options.delete(:section_id)
        call_options = {}
        call_options[:id] = section_id if section_id

        options[:verb] = :create
        call_options[:body] = payload_class.new(options).xml

        response       = call_client_method(:create, call_options)
        id             = response.header['location'].split('/').last
        self.for_id(id)
      end

      def perform_update(payload_class, object_class, options={})
        options  = options.merge({id: id, verb: :update})
        payload  = payload_class.new(options)
        response = call_client_method(:update, {id: id, body: payload.xml})

        if response.instance_of?(Net::HTTPNoContent)
          object_class.for_id(id)
        else
          raise Escenic::API::Error 'update failed'
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

      def call_client_method(method, options)
        method = resolve_method(method)
        Escenic::API::client.endpoints.send(method, options)
      end

      def self.call_client_method(method, options)
        method = self.resolve_method(method, self.name.split('::').last.downcase)
        Escenic::API::client.endpoints.send(method, options)
      end
    end

  end
end