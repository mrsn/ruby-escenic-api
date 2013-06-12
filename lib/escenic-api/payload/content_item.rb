module Escenic
  module API

    class ContentItemPayload < Escenic::API::Payload


      def initialize(options={})
        super options # model_type is handled externally
        handle_verb options
      end

      def create(options={})
        api_xml_base(options) { |xml|
          xml.title options.delete(:title), type: 'text'
          xml[:app].control { xml[:app].draft 'yes' }
        }
      end


      def update(options={})
        response = Escenic::API::client.endpoints.get_xml_content_item(id: options.delete(:id))
        update_fields(response, options)
      end

    end

  end
end
