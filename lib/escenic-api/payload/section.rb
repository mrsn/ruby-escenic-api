module Escenic
  module API

    class SectionPayload < Escenic::API::Payload

      attr_reader :model_type, :xml

      def initialize(options={})
        super
        @model_type = 'com.escenic.section'
        case options.delete(:verb)
          when :create
            @xml = create(options)
          when :delete
            @xml = delete(options)
          else
            raise Escenic::API::Error.new('Invalid verb: ' + options[:verb])
        end
      end

      def create(options={})
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns: 'http://www.w3.org/2005/Atom',
              'xmlns:app' => 'http://www.w3.org/2007/app',
              'xmlns:metadata' => 'http://xmlns.escenic.com/2010/atom-metadata',
              'xmlns:dcterms' => 'http://purl.org/dc/terms/'
          ) {
            xml.link(
                rel: 'http://www.vizrt.com/types/relation/parent',
                href: endpoint + '/section/' + parent_id,
                title: parent_title,
                type: 'application/atom+xml; type=entry'
            )
            xml.content(type: 'application/vnd.vizrt.payload+xml') {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model: base_model + '/' + model_type
              ) {
                options.each do |key, value|
                  xml[:vdf].field(name: "com.escenic.#{key}") {
                    xml[:vdf].value value
                  }
                end
              }
            }
          }
        end
        builder.to_xml
      end

      def delete(options={})
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns: 'http://www.w3.org/2005/Atom',

          ) {
            xml.content(type: 'application/vnd.vizrt.payload+xml') {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model: endpoint + '/model/' + model_type + '.delete.' + options.delete(:id).to_s
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

    end
  end
end