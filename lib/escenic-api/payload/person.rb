module Escenic
  module API

    class PersonPayload < Escenic::API::Payload
      def initialize(options={})
        options[:type] = 'com.escenic.person'
        super options
        handle_verb options
      end

      def create(options={})
        api_xml_base(options) {}
      end


      def update(options={})
        response = Escenic::API::client.endpoints.get_person({}, {id: options[:id]})
        update_fields(response, options)
      end
    end
  end
end