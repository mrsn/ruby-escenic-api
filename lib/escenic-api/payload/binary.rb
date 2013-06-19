module Escenic
  module API

    class BinaryPayload < Escenic::API::Payload


      def initialize(options={})
        super options # model_type is handled externally
        handle_verb options
      end

      def create(options={})
        load_file(options[:filename])
      end


      def update(options={})
        load_file(options[:filename])
      end

      def load_file(filename)
        open(filename, 'rb') { |io| io.read }
      end
    end

  end
end
