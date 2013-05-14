module Escenic
  module API

    class Section < Escenic::API::Object

      def self.init(options={}, client)
        if options[:id].nil?
          # Try to create a section.
          self.create(options={}, client)
        elsif options[:id] && options.count == 1
          # Try to retrieve a section.
          response = client.raw.get_section(:id => options[:id])
          super(response, client)
        else
          # Missing params.
          raise Escenic::API::Error::Params.new 'Section ID or name, unique name, and directory required.'
        end
      end

      def self.create(options={}, client)
        raise Escenic::API::Error::Params.new 'Section name, unique name, and directory required to create a section.' if
            options[:name].nil?         ||
            options[:unique_name].nil?  ||
            options[:directory].nil?
        # Create payload *pending*

        # Create the section
        response = client.raw.create_section(payload)
        instance = self.new(response)
        instance.client = client
        instance
      end

      def update

      end

      def delete

      end

    end

  end
end