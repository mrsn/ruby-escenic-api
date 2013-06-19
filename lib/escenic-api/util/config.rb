module Escenic
  module API

    module Config

      class << self
        attr_accessor :base_url
        attr_accessor :user
        attr_accessor :pass
        attr_accessor :publication
        attr_accessor :endpoint
        attr_accessor :base_model
        attr_accessor :endpoint_binary
      end

      self.base_url     = nil
      self.user         = nil
      self.pass         = nil
      self.publication  = nil
      self.endpoint     = nil
      self.base_model   = nil
      self.endpoint_binary = nil

      def self.http_ready?
        not (Escenic::API::Config.user.nil? || Escenic::API::Config.pass.nil? || Escenic::API::Config.base_url.nil?)
      end
    end

  end
end