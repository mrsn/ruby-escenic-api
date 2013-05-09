$:.push File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

require 'escenic'
require 'rspec'
require 'webmock/rspec'

Dir.glob("#{File.dirname(__FILE__)}/support/*.rb").each {|f| require "#{f}" }
