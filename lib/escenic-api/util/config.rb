module Escenic
  module API

    module Config

      class << self
        attr_accessor :endpoint
        attr_accessor :user
        attr_accessor :pass
        attr_accessor :publication
      end

      self.endpoint     = nil
      self.user         = nil
      self.pass         = nil
      self.publication  = nil

    end

  end
end