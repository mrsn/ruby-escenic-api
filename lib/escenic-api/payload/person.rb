module Escenic
  module API

    class PersonPayload < Escenic::API::Payload
      def initialize(options={})
        options[:type] = 'com.escenic.person'
        super options
        handle_verb options
      end

      def create(options={})
        options = {vdf_field_prefix: 'com.escenic.'}.merge(options)
        api_xml_base(options) {}
      end


      def update(options={})
        response = Escenic::API::client.raw.get_xml_person(id: options.delete(:id))
        update_fields(response, options)
      end
    end
  end
end