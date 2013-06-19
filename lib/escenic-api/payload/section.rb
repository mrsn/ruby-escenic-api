module Escenic
  module API

    class SectionPayload < Escenic::API::Payload

      attr_reader :model_type, :xml

      def initialize(options={})
        options[:type] = 'com.escenic.section'
        super options
        handle_verb options
      end

      def create(options={})
        options = {vdf_field_prefix: 'com.escenic.'}.merge(options)
        api_xml_base(options) { |xml|
          xml.link(
              rel:   'http://www.vizrt.com/types/relation/parent',
              href:  endpoint + '/section/' + parent_id,
              title: parent_title,
              type:  'application/atom+xml; type=entry'
          )
        }
      end

      def delete(options={})
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns: 'http://www.w3.org/2005/Atom',
          ) {
            xml.content(type: 'application/vnd.vizrt.payload+xml') {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model:      endpoint + '/model/' + model_type + '.delete.' + options.delete(:id).to_s
              ) {
                xml[:vdf].field(name: 'com.escenic.section.delete.confirmation') {
                  xml[:vdf].value 'true'
                }
              }
            }
          }
        end
        builder.to_xml
      end

      def update(options={})
        response  = Escenic::API::client.endpoints.get_section({}, id: options.delete(:id))
        update_fields(response, options)
      end

    end
  end
end