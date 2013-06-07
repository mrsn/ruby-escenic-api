module Escenic
  module API

    class ContentItemPayload < Escenic::API::Payload

      attr_reader :model_type, :xml

      def initialize(options={})
        super
        @model_type = options.delete(:type)
        case options.delete(:verb)
          when :create
            @xml = create(options)
          when :update
            @xml = update(options)
          else
            raise Escenic::API::Error.new('Invalid verb: ' + options[:verb])
        end
      end

      private
      def create(options={})
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns: 'http://www.w3.org/2005/Atom',
              'xmlns:app' => 'http://www.w3.org/2007/app',
              'xmlns:metadata' => 'http://xmlns.escenic.com/2010/atom-metadata',
              'xmlns:dcterms' => 'http://purl.org/dc/terms/'
          ) {
            xml.title options.delete(:title), type: 'text'
            xml[:app].control { xml[:app].draft 'yes' }
            xml.content( type: 'application/vnd.vizrt.payload+xml' ) {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model: "#{base_model}/#{model_type}"
              ) {
                options.each do |key, value|
                  xml[:vdf].field(name: "#{key}") {
                    xml[:vdf].value value
                  }
                end
              }
            }
          }
        end
        builder.to_xml
      end

      def update(options={})
        response  = Escenic::API::client.raw.get_content_item_xml(id: options.delete(:id))
        builder   = Nokogiri::XML(response)
        namespace = builder.collect_namespaces
        payload   = builder.xpath('//vdf:payload', namespace)

        options.each do |k, value|
          key = k.to_s
          field = builder.xpath('//vdf:field[@name = "' + key + '"]', namespace).children
          if field.count == 0
            # add the field to the xml
            vdf_field = Nokogiri::XML::Node.new('vdf:field', builder)
            vdf_value = Nokogiri::XML::Node.new('vdf:value', builder)
            vdf_field.set_attribute 'name', key
            vdf_value.content = value
            vdf_field.add_child(vdf_value)
            payload.children.first.add_previous_sibling(vdf_field)
          else
            field.first.content = value
          end
        end
        builder.to_xml
      end

    end

  end
end
