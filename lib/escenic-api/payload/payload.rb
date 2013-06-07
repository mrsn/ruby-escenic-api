module Escenic
  module API

    class Payload
      attr_reader :verb, :model_type, :xml, :endpoint, :publication, :base_model, :parent_id, :parent_title

      def initialize(options={})
        @endpoint     = Escenic::API::Config.endpoint
        @model_type   = options.delete(:type)
        @publication  = Escenic::API::Config.publication
        @base_model   = Escenic::API::Config.base_model
        @parent_id    = ( options.delete(:parentId)     || Escenic::API::client.root.content.feed.entry.identifier ).to_s
        @parent_title = ( options.delete(:parentTitle)  || Escenic::API::client.section( id:@parent_id ).content.entry.title )
        @verb = options.delete(:verb).to_sym || raise(Escenic::API::Error::Params.new ':verb is required.')
      end

      def handle_verb(options)
        if self.respond_to? @verb
          @xml = self.send(@verb, options)
        else
          raise Escenic::API::Error.new('Invalid verb: ' + @verb)
        end
      end

    end

  end
end