module Escenic
  module API

    class Person < Escenic::API::Object
      def self.create(options={})
        perform_create(Escenic::API::PersonPayload, {}, options)
      end

      def self.verify_options(options)
        raise Escenic::API::Error::Params.new 'surname is required to create a person.' if options[:surName].nil?
      end

      def update(options={})
        perform_update(
            Escenic::API::PersonPayload,
            Escenic::API::Person,
            {},
            options
        )
      end

      def delete?
        perform_delete(Net::HTTPNoContent)
      end
    end
  end
end