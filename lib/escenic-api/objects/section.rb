module Escenic
  module API

    class Section < Escenic::API::Object

      def self.init(options={})
        if options[:id].nil?
          # Try to create a section.
          self.create(options)
        elsif options[:id] && options.count == 1
          # Try to retrieve a section.
          response = self.client.raw.get_section(:id => options[:id])
          self.new(response)
        else
          # Missing params.
          raise Escenic::API::Error::Params.new 'Section ID or name, unique name, and directory required.'
        end
      end

      def self.create(options={})
        raise Escenic::API::Error::Params.new 'sectionName, uniqueName, and directoryName required to create a section.' if
            options[:sectionName].nil?  ||
            options[:uniqueName].nil?   ||
            options[:directoryName].nil?

        # Create payload
        options[:verb]  = :create
        payload         = Escenic::API::SectionPayload.new(options)

        # Create the section
        response  = self.client.raw.create_section(body: payload.xml)
        id        = response.header['location'].split('/').last
        instance  = self.init({id: id})
        instance
      end

      def update?(options={})
        options[:id]    = self.entry.identifier
        options[:verb]  = :update
        payload   = Escenic::API::SectionPayload.new(options)
        response  = self.client.raw.update_section(id: self.entry.identifier, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          true
        else
          false
        end

      end

      def delete?
        id        = self.entry.identifier
        options   = { id: id, verb: :delete }
        payload   = Escenic::API::SectionPayload.new(options)
        response  = self.client.raw.delete_section_confirm(id: id, body: payload.xml)

        if response.instance_of?(Net::HTTPNoContent)
          self.each do |k,v|
            self.delete(k.to_sym)
          end
          true
        else
          false
        end

      end

      def subsections
        response = self.client.get_subsections(id: self.entry.identifier)
        # Return a list of subsections for a section
      end

    end

  end
end