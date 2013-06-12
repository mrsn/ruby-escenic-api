module Escenic
  module API

    class Person < Escenic::API::Object

      def self.for_id(id)
        raise 'id must not be nil' if id.nil?
        response = Escenic::API::client.endpoints.get_person(id: id)
        self.new(response)
      end

      def self.create(options={})
        raise Escenic::API::Error::Params.new 'surname is required to create a person.' if options[:surName].nil?

        # Create payload
        options[:verb] = :create
        payload        = Escenic::API::PersonPayload.new(options)

        # Create the person
        response       = Escenic::API::client.endpoints.create_person(body: payload.xml)
        id             = response.header['location'].split('/').last
        self.for_id(id) # return a copy of self, re-fetched from server.
      end

      def update(options={})
        options  = options.merge({id: id, verb: :update})
        payload  = Escenic::API::PersonPayload.new(options)
        response = Escenic::API::client.endpoints.update_person(id: id, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          Escenic::API::Person.for_id(id)
        else
          raise Escenic::API::Error 'update failed.'
        end
      end

      def delete?
        response = Escenic::API::client.endpoints.delete_person(id: id)

        if response.instance_of?(Net::HTTPNoContent)
          @content.each_key do |k|
            @content.delete(k.to_sym)
          end
          true
        else
          false
        end

      end
    end

  end
end