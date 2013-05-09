require 'spec_helper'

describe Escenic::API::Client do

  before do
    @client = Escenic::API::Client.new
  end

  describe "#connection" do
    it 'should be an instance of Escenic::API::Connection' do
      conn = @client.instance_variable_get(:@connection)
      conn.should be_an_instance_of(Escenic::API::Connection)
    end
  end




end