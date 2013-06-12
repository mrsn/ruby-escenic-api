require 'uri'
require 'json'
require 'hashie'
require 'net/http'
require 'nokogiri'

module Escenic
  module API
    def self.client
      @@client ||= Escenic::API::Client.new
    end
  end
end

require_relative 'escenic-api/version'
require_relative 'escenic-api/client'
require_relative 'escenic-api/util/config'
require_relative 'escenic-api/util/error'
require_relative 'escenic-api/util/hash'
require_relative 'escenic-api/client/endpoints'
require_relative 'escenic-api/client/connection'
require_relative 'escenic-api/objects/object'
require_relative 'escenic-api/objects/root'
require_relative 'escenic-api/objects/spec'
require_relative 'escenic-api/objects/section'
require_relative 'escenic-api/objects/content_item'
require_relative 'escenic-api/objects/person'
require_relative 'escenic-api/payload/payload'
require_relative 'escenic-api/payload/section'
require_relative 'escenic-api/payload/content_item'
require_relative 'escenic-api/payload/person'