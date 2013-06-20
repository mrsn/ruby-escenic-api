module Escenic
  module API

    class ContentItem < Escenic::API::Object
      def self.create(options={})
        if options[:filename]
          raise 'content_type missing' if options[:type].nil?
          binary_location = Escenic::API::Binary.create(options)
          content_id      = binary_location.split('/').last

          ContentItem.for_id(content_id)
        else
          perform_create(Escenic::API::ContentItemPayload, {}, options)
        end
      end

      def verify_options(options)
        raise Escenic::API::Error::Params.new 'type and section id are required to create a content item.' if
            options[:type].nil? ||
            options[:section_id].nil?
      end

      def update(options={})
        perform_update(
            Escenic::API::ContentItemPayload,
            Escenic::API::ContentItem,
            {},
            options
        )
      end

      def delete?
        perform_delete(Net::HTTPOK)
      end
    end
  end
end

