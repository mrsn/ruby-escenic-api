module Escenic
  module API

    class Payload
      include ERB::Util

      def initialize(options={})

      end

      def wrapper
        %{
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom" xmlns:app="http://www.w3.org/2007/app" xmlns:metadata="http://xmlns.escenic.com/2010/atom-metadata" xmlns:dcterms="http://purl.org/dc/terms/">
  <link rel="http://www.vizrt.com/types/relation/parent" href="http://host-ip-address/webservice/escenic/section/1"
        title="Home" type="application/atom+xml; type=entry"></link>
  <content type="application/vnd.vizrt.payload+xml">
    <vdf:payload xmlns:vdf="http://www.vizrt.com/types"
                 model="http://host-ip-address/webservice/publication/publication-id/escenic/model/com.escenic.section">
      <vdf:field name="com.escenic.sectionname">
        <vdf:value>New Section</vdf:value>
      </vdf:field>
      <vdf:field name="com.escenic.uniquename">
        <vdf:value>new_section</vdf:value>
      </vdf:field>
      <vdf:field name="com.escenic.directoryname">
        <vdf:value>new_section</vdf:value>
      </vdf:field>
    </vdf:payload>
  </content>
</entry>
        %}
      end

    end

  end
end