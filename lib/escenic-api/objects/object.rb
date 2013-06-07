module Escenic
  module API

    class Object
      attr_accessor :content

      def initialize(content)
        @content = Hashie::Mash.new(content)
      end

    end

  end
end