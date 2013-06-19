module Escenic
  module API

    class ContentItemPayload < Escenic::API::Payload


      def initialize(options={})
        super options # model_type is handled externally
        handle_verb options
      end

      def create(options={})
        api_xml_base(options) { |xml|
          xml.title options[:title], type: 'text'
          xml[:app].control { xml[:app].draft 'yes' }
        }
      end


      def update(options={})
        response = Escenic::API::client.endpoints.get_contentitem({}, {id: options[:id]})
        update_fields(response, options)
      end

    end

  end
end
