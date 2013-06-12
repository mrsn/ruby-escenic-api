module Escenic
  module API

    class ContentItem < Escenic::API::Object
      def self.create(options={})
        raise Escenic::API::Error::Params.new 'type and section id are required to create a content item.' if options[:type].nil? ||
            options[:section_id].nil?

        section_id     = options.delete(:section_id)

        # Create payload
        options[:verb] = :create
        payload        = Escenic::API::ContentItemPayload.new(options)

        # Create the content item
        response       = call_client_method(:create, {body: payload.xml, id: section_id})
        id             = response.header['location'].split('/').last
        self.for_id(id)
      end

      def update(options={})
        options  = options.merge({id: id, verb: :update})
        payload  = Escenic::API::ContentItemPayload.new(options)
        response = call_client_method(:update, {id: id, body: payload.xml})

        if response.instance_of?(Net::HTTPNoContent)
          Escenic::API::ContentItem.for_id(id)
        else
          raise Escenic::API::Error 'update failed'
        end

      end

      def delete?
        response = call_client_method(:delete, {id: id})

        if response.instance_of?(Net::HTTPOK)
          content.each_key do |k|
            content.delete(k.to_sym)
          end
          true
        else
          false
        end

      end

    end

  end
end

