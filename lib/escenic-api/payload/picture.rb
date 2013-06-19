module Escenic
  module API

    class PicturePayload < Escenic::API::Payload


      def initialize(options={})
        options[:type] = 'picture'
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
        response = Escenic::API::client.endpoints.get_contentitem({}, id: options.delete(:id))
        options[:prefixed] = false
        update_fields(response, options)
      end

    end

  end
end
