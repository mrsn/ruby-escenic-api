require 'mime/types'
require_relative '../payload/binary'
require_relative '../payload/picture'

module Escenic
  module API
    class Picture < Escenic::API::Object
      def self.create(options={})
        options[:id]    = 'picture'
        binary_location = Escenic::API::Binary.create(options)
        picture_id      = binary_location.split('/').last
        Picture.for_id(picture_id)
      end

      def update(options={})
        perform_update(
            Escenic::API::PicturePayload,
            Escenic::API::Picture,
            {},
            options
        )
      end
    end
  end
end
