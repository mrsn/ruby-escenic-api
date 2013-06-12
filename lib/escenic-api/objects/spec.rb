module Escenic
  module API

    class Spec < Escenic::API::Object
      attr_reader :fields

      def initialize(xml)
        super(xml)
        process_field_names
      end

      def self.init(options={})
        if options[:id].nil?
          raise 'id is missing from the request.'
        else
          response = Escenic::API::client.raw.get_spec(options)
        end

        self.new(response)
      end

      def process_field_names
        @fields = []
        @content.model.schema.fielddef.each { |hash|
          @fields.push(hash.attributes.name)
        }
      end

      def validate(xml)
        payload_hash = Hashie::Mash.new(Hash.from_xml(xml))

        payload_hash.entry.content.payload.field.each { |field|
          if field.respond_to?(:attributes) && !@model_type.nil?
            field_name = field.attributes.name
            warn "Field #{field_name} is not in #{@model_type} spec!" unless @fields.include? field_name
          end
        }
      end
    end

  end
end
