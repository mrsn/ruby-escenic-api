module Escenic
  module API

    class Payload
      include ERB::Util

      def initialize(options={}, client)
        @endpoint = client.endpoint
        @publication = Escenic::API::Config.publication
        @model = client.base_model

      end

      def wrapper
        %{
<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom" xmlns:app="http://www.w3.org/2007/app" xmlns:metadata="http://xmlns.escenic.com/2010/atom-metadata" xmlns:dcterms="http://purl.org/dc/terms/">
  <link rel="http://www.vizrt.com/types/relation/parent" href="#{self.base_url}/section/1"
        title="Home" type="application/atom+xml; type=entry"></link>
  <content type="application/vnd.vizrt.payload+xml">
    <vdf:payload xmlns:vdf="http://www.vizrt.com/types"
                 model="#{self.model}/com.escenic.section">
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