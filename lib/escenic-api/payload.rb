module Escenic
  module API

    class Payload

      def initialize(options={}, client)
        @endpoint     = client.endpoint
        @publication  = Escenic::API::Config.publication
        @base_model   = client.base_model
        @parent_id    = options[:parent_id]    || client.root_section.feed.entry.identifier
        @parent_title = options[:parent_title] || client.root_section.feed.entry.title
      end

    end

  end
end