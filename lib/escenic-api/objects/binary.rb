require 'mime/types'
require_relative '../payload/binary'

module Escenic
  module API

    class Binary < Escenic::API::Object
      def self.create(options={})
        filename = options[:filename]
        headers  = options[:headers] || {}
        basename = filename.split('/').last

        options = options.merge({verb: :create})
        payload = Escenic::API::BinaryPayload.new(options)

        headers['x-escenic-media-filename'] = basename
        headers['content-type']             = MIME::Types.type_for(filename).first.to_s
        options                             = {
            body:          payload.body,
            endpoint_type: :binary,
        }.merge(options)

        response = call_client_method(:create, headers, options)

        if response.instance_of?(Net::HTTPCreated)
          response.header['location']
        else
          raise 'create failed'
        end
      end

      def verify_options(options)
        raise Escenic::API::Error::Params.new 'type, content_type and filename are required to create a content item.' if options[:type].nil? ||
            options[:content_type].nil? ||
            options[:filename].nil?
      end
    end
  end
end

