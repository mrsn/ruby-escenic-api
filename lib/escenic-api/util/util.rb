
module Escenic
  module API

    module Util

      class << self

        def create_section_payload(data = {})
          default_parent = Escenic::API::Section.new.subsections('ROOT')

          #Nokogiri::XML::Reader(default_parent).each do |node|
          #  node.inspect
          #end

          defaults = {
              parent_title: 'Home',
              parent_id: '4'
          }
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.entry(
                xmlns: 'http://www.w3.org/2005/Atom',
                'xmlns:app' => 'http://www.w3.org/2007/app',
                'xmlns:metadata' => 'http://xmlns.escenic.com/2010/atom-metadata',
                'xmlns:dcterms' => 'http://purl.org/dc/terms/'
            ) {
              xml.link(
                  rel: 'http://www.vizrt.com/types/relation/parent',
                  href: "#{API_URL}section/#{defaults[:parent_id]}",
                  title: "#{defaults[:parent_title]}",
                  type: 'application/atom+xml; type=entry'
              )
              xml.content(type: 'application/vnd.vizrt.payload+xml') {
                xml[:vdf].payload(
                    'xmlns:vdf' => 'http://www.vizrt.com/types',
                    model: "http://localhost:8080/webservice/publication/#{EnvSettings.configs[:api_publication]}/escenic/model/com.escenic.section"
                ) {
                  xml[:vdf].field( name: 'com.escenic.sectionName' ) {
                    xml[:vdf].value data_hash[:name]
                  }
                  xml[:vdf].field( name: 'com.escenic.uniqueName' ) {
                    xml[:vdf].value data_hash[:unique_name]
                  }
                  xml[:vdf].field( name: 'com.escenic.directoryName' ) {
                    xml[:vdf].value data_hash[:unique_name]
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
end