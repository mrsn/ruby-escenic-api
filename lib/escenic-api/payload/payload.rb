module Escenic
  module API

    class Payload
      attr_reader :verb, :model_type, :body, :endpoint, :publication, :base_model, :parent_id, :parent_title

      def initialize(options={})
        @endpoint     = Escenic::API::Config.endpoint
        @model_type   = options.delete(:type)
        @publication  = Escenic::API::Config.publication
        @base_model   = Escenic::API::Config.base_model
        @parent_id    = (options.delete(:parentId) || Escenic::API::client.root.content.feed.entry.identifier).to_s
        @parent_title = (options.delete(:parentTitle) || Escenic::API::Section.for_id(@parent_id).content.entry.title)
        @verb         = options.delete(:verb).to_sym || raise(Escenic::API::Error::Params.new ':verb is required.')
      end

      def handle_verb(options)
        if self.respond_to? @verb
          @body = self.send(@verb, options)
          #if [:create, :update].include? @verb
          #  spec.validate xml
          #end
        else
          raise Escenic::API::Error.new('Invalid verb: ' + @verb)
        end
      end

      def update_fields(response, options)
        builder    = Nokogiri::XML(response)
        namespaces = builder.collect_namespaces
        payload    = builder.xpath('//vdf:payload', namespaces)

        prefixed = options.delete(:prefixed)
        options.each do |k, value|
          if prefixed
            name       = "com.escenic.#{k.to_s}"
          else
            name       = k.to_s
          end

          attr_field = payload.xpath("//vdf:field[@name='#{name}']", namespaces)
          if attr_field.count > 0 && attr_field.children.count == 0 # field exists and is empty
            vdf_value = vdf_value(builder, value)
            attr_field.first.add_child(vdf_value)
          elsif attr_field.count == 1 && attr_field.children.count == 1 # field already has a value element
            attr_field.xpath('//vdf:value', namespaces).children.first.content = value
          else # field does not exist at all.
            vdf_value = vdf_value(builder, value)
            vdf_field = vdf_field(builder, name)
            vdf_field.add_child(vdf_value)
            payload.children.first.add_previous_sibling(vdf_field)
          end
        end
        builder.to_xml
      end

      def vdf_value(builder, value)
        vdf_value         = Nokogiri::XML::Node.new('vdf:value', builder)
        vdf_value.content = value
        vdf_value
      end

      def vdf_field(builder, field_name)
        vdf_field = Nokogiri::XML::Node.new('vdf:field', builder)
        vdf_field.set_attribute 'name', field_name
        vdf_field
      end


      def api_xml_base(options={})
        field_prefix = options.delete(:vdf_field_prefix)
        builder      = Nokogiri::XML::Builder.new do |xml|
          xml.entry(
              xmlns:           'http://www.w3.org/2005/Atom',
              'xmlns:app'      => 'http://www.w3.org/2007/app',
              'xmlns:metadata' => 'http://xmlns.escenic.com/2010/atom-metadata',
              'xmlns:dcterms'  => 'http://purl.org/dc/terms/'
          ) {

            yield xml

            xml.content(type: 'application/vnd.vizrt.payload+xml') {
              xml[:vdf].payload(
                  'xmlns:vdf' => 'http://www.vizrt.com/types',
                  model:      "#{base_model}/#{model_type}"
              ) {
                options.each do |key, value|
                  xml[:vdf].field(name: "#{field_prefix}#{key}") {
                    xml[:vdf].value value
                  }
                end
              }
            }
          }
        end
        builder.to_xml
      end

      def spec
        @spec ||= Escenic::API::client.spec(id: @model_type)
      end

    end
  end
end