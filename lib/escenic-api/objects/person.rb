module Escenic
  module API

    class Person < Escenic::API::Object

      def self.init(options={})
        if options[:id].nil?
          # Try to create a person.
          self.create(options)
        elsif options[:id] && options.count == 1
          # Try to retrieve a person.
          response = Escenic::API::client.raw.get_person(id: options[:id])
          self.new(response)
        else
          # Missing params.
          raise Escenic::API::Error::Params.new 'init can only create a new or retrieve an old entry.'
        end
      end

      def self.create(options={})
        raise Escenic::API::Error::Params.new 'surname is required to create a person.' if options[:surName].nil?

        # Create payload
        options[:verb] = :create
        payload        = Escenic::API::PersonPayload.new(options)

        # Create the person
        response       = Escenic::API::client.raw.create_person(body: payload.xml)
        id             = response.header['location'].split('/').last
        self.init({id: id}) # return a copy of self, re-fetched from server.
      end

      def update(options={})
        id       = @content.entry.identifier
        options  = options.merge({id: id, verb: :update})
        payload  = Escenic::API::PersonPayload.new(options)
        response = Escenic::API::client.raw.update_person(id: id, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          Escenic::API::Person.init({id: id})
        else
          raise Escenic::API::Error 'update failed.'
        end
      end

      def delete?
        id       = @content.entry.identifier
        response = Escenic::API::client.raw.delete_person(id: id)

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