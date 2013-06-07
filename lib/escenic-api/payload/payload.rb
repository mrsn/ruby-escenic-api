module Escenic
  module API

    class Payload
      attr_reader :endpoint, :publication, :base_model, :parent_id, :parent_title

      def initialize(options={})
        @endpoint     = Escenic::API::Config.endpoint
        @publication  = Escenic::API::Config.publication
        @base_model   = Escenic::API::Config.base_model
        @parent_id    = ( options.delete(:parentId)     || Escenic::API::client.root.content.feed.entry.identifier ).to_s
        @parent_title = ( options.delete(:parentTitle)  || Escenic::API::client.section( id:@parent_id ).content.entry.title )
      end

    end

  end
end