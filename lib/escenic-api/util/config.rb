module Escenic
  module API

    module Config

      class << self
        attr_accessor :base_url
        attr_accessor :user
        attr_accessor :pass
        attr_accessor :publication
      end

      self.base_url     = nil
      self.user         = nil
      self.pass         = nil
      self.publication  = nil

    end

  end
end