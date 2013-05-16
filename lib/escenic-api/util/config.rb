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
      end

      self.base_url     = nil
      self.user         = nil
      self.pass         = nil
      self.publication  = nil
      self.endpoint     = nil
      self.base_model   = nil

    end

  end
end