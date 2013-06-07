module Escenic
  module API

    class Section < Escenic::API::Object

      def self.init(options={})
        if options[:id].nil?
          # Try to create a section.
          self.create(options)
        elsif options[:id] && options.count == 1
          # Try to retrieve a section.
          response = Escenic::API::client.raw.get_section(id: options[:id])
          self.new(response)
        else
          # Missing params.
          raise Escenic::API::Error::Params.new 'Section ID or name, unique name, and directory required.'
        end
      end

      def self.create(options={})
        raise Escenic::API::Error::Params.new 'sectionName, uniqueName, and directoryName required to create a section.' if options[:sectionName].nil? ||
            options[:uniqueName].nil? ||
            options[:directoryName].nil?

        # Create payload
        options[:verb] = :create
        payload        = Escenic::API::SectionPayload.new(options)

        # Create the section
        response       = Escenic::API::client.raw.create_section(body: payload.xml)
        id             = response.header['location'].split('/').last
        self.init({id: id}) # return a copy of self, re-fetched from server.
      end

      def update(options={})
        id       = @content.entry.identifier
        options  = options.merge({id: id, verb: :update})
        payload  = Escenic::API::SectionPayload.new(options)
        response = Escenic::API::client.raw.update_section(id: id, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          Escenic::API::Section.init({id: id})
        else
          raise Escenic::API::Error 'update failed.'
        end
      end

      def delete?
        id       = @content.entry.identifier
        options  = {id: id, verb: :delete}
        payload  = Escenic::API::SectionPayload.new(options)
        response = Escenic::API::client.raw.delete_section_confirm(id: id, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          @content.each_key do |k|
            @content.delete(k.to_sym)
          end
          true
        else
          false
        end

      end

      # Return a list of subsections for a section
      def subsections
        Escenic::API::client.get_subsections(id: self.content.entry.identifier)
      end
    end

  end
end