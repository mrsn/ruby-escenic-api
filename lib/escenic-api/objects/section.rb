module Escenic
  module API

    class Section < Escenic::API::Object

      def self.init(options={})
        client = Escenic::API::Client.new
        if options[:id].nil?
          # Try to create a section.
          self.create(options, client)
        elsif options[:id] && options.count == 1
          # Try to retrieve a section.
          response = client.raw.get_section(:id => options[:id])
          super(response)
        else
          # Missing params.
          raise Escenic::API::Error::Params.new 'Section ID or name, unique name, and directory required.'
        end
      end

      def self.create(options={}, client)
        raise Escenic::API::Error::Params.new 'secctionName, uniqueName, and directoryName required to create a section.' if
            options[:sectionName].nil?  ||
            options[:uniqueName].nil?   ||
            options[:directoryName].nil?
        client = Escenic::API::Client.new
        # Create payload *pending*
        options[:verb] = :create
        payload = Escenic::API::SectionPayload.new(options)
        # Create the section
        response = client.raw.create_section(body: payload.xml)
        id = response.header['location'].split('/').last
        instance = self.init({id: id})
        instance
      end

      def update

      end

      def delete
        id = self.entry.identifier
        payload = Escenic::API::SectionPayload.new({verb: :delete, id: id})
        client.raw.confirm_delete(id: id, body: payload.xml)
      end

    end

  end
end