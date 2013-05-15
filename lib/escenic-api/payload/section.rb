module Escenic
  module API

    class SectionPayload < Escenic::API::Payload

      attr_accessor :model_type, :xml

      def initialize(options={}, client)
        super
        @model_type = 'com.escenic.section'
        @xml = section(options)
      end

      def section(options={})
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns: 'http://www.w3.org/2005/Atom',
              'xmlns:app' => 'http://www.w3.org/2007/app',
              'xmlns:metadata' => 'http://xmlns.escenic.com/2010/atom-metadata',
              'xmlns:dcterms' => 'http://purl.org/dc/terms/'
          ) {
            xml.link(
                rel: 'http://www.vizrt.com/types/relation/parent',
                href: "#{@endpoint}/section/#{@parent_id}",
                title: "#{@parent_title}",
                type: 'application/atom+xml; type=entry'
            )
            xml.content(type: 'application/vnd.vizrt.payload+xml') {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model: "#{@base_model}/#{@model_type}"
              ) {
                xml[:vdf].field( name: 'com.escenic.sectionName' ) {
                  xml[:vdf].value options[:name]
                }
                xml[:vdf].field( name: 'com.escenic.uniqueName' ) {
                  xml[:vdf].value options[:unique_name]
                }
                xml[:vdf].field( name: 'com.escenic.directoryName' ) {
                  xml[:vdf].value options[:directory]
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