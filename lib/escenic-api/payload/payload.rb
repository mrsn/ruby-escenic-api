module Escenic
  module API

    class Payload
      attr_reader :client, :endpoint, :publication, :base_model, :parent_id, :parent_title

      def initialize(options={})
        @client       = Escenic::API::Client.new
        @endpoint     = Escenic::API::Config.endpoint
        @publication  = Escenic::API::Config.publication
        @base_model   = Escenic::API::Config.base_model
        @parent_id    = ( options.delete(:parentId)     || @client.root.feed.entry.identifier ).to_s
        @parent_title = ( options.delete(:parentTitle)  || @client.root.feed.entry.title )
      end

    end

  end
end