module Escenic
  module API

    class Section < Escenic::API::Object
      def self.create(options={})
        perform_create(Escenic::API::SectionPayload, options)
      end

      def self.verify_options(options)
        raise Escenic::API::Error::Params.new 'sectionName, uniqueName, and directoryName required to create a section.' if options[:sectionName].nil? ||
            options[:uniqueName].nil? ||
            options[:directoryName].nil?
      end

      def update(options={})
        perform_update(
            Escenic::API::SectionPayload,
            Escenic::API::Section,
            options
        )
      end

      def delete?
        perform_delete_confirm(Escenic::API::SectionPayload, Net::HTTPNoContent)
      end

      # Return a list of subsections for a section
      def subsections
        Escenic::API::client.get_subsections(id: id)
      end
    end

  end
end