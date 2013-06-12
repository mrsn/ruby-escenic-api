module Escenic
  module API

    class ContentItem < Escenic::API::Object
      def self.create(options={})
        perform_create(Escenic::API::ContentItemPayload, options)
      end

      def verify_options(options)
        raise Escenic::API::Error::Params.new 'type and section id are required to create a content item.' if options[:type].nil? ||
            options[:section_id].nil?
      end

      def update(options={})
        perform_update(
            Escenic::API::ContentItemPayload,
            Escenic::API::ContentItem,
            options
        )
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

