require_relative '../document/spec_document'

module Escenic
  module API
    class Spec < Escenic::API::Object
      attr_reader :fields

      def initialize(xml)
        super(xml)
        parse_spec
      end

      def parse_spec
        spec = SpecDocument.new
        spec_parser = Nokogiri::XML::SAX::Parser.new(spec)
        spec_parser.parse(raw)
        @fields = spec.fields
      end

      def validate(payload)
        xml = Nokogiri::XML::Document.parse(payload.body)

        #payload_hash = Hashie::Mash.new(Hash.from_xml(xml))

        namespaces = xml.collect_namespaces

        names = xml.xpath('//vdf:field/@name', namespaces)
        mismatches = []
        names.each do |name|
          mismatches.push(name) unless @fields.include? name.to_s
        end
        mismatches.each do |name|
          warn "Field #{name} is not in spec!"
        end
      end
    end
  end
end
