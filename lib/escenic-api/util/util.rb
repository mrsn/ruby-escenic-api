
module Escenic
  module API

    module Util

      class << self

        def create_section_payload(data = {})
          #default_parent = Escenic::API::Section.new.subsections('ROOT')
          #Nokogiri::XML::Reader(default_parent).each do |node|
          #  node.inspect
          #end

          defaults = {
              parent_title: 'Home',
              parent_id: '4'
          }


          builder.to_xml
        end

      end

    end

  end
end