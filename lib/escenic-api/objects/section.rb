module Escenic
  module API

    class Section < Escenic::API::Object
      def self.create(options={})
        perform_create(Escenic::API::SectionPayload, {}, options)
      end

      def self.verify_options(options)
        fields = options[:fields]
        raise Escenic::API::Error::Params.new 'fields hash is missing completely in section call. Cannont continue.' if fields.nil?
        raise Escenic::API::Error::Params.new 'com.escenic.sectionName, com.escenic.uniqueName, and com.escenic.directoryName required to create a section.' if
          fields['com.escenic.sectionName'].nil? ||
          fields['com.escenic.uniqueName'].nil? ||
          fields['com.escenic.directoryName'].nil?
      end

      def update(options={})
        perform_update(
            Escenic::API::SectionPayload,
            Escenic::API::Section,
            {},
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