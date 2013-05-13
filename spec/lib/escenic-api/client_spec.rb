require 'spec_helper'

describe Escenic::API::Client do

  before do
    @client = Escenic::API::Client.new
  end

  describe '#connection' do
    it 'should be an instance of Escenic::API::Connection' do
      conn = @client.instance_variable_get(:@connection)
      conn.should be_an_instance_of(Escenic::API::Connection)
    end
  end

  describe '#section' do
    user = Escenic::API::Config.user
    pass = Escenic::API::Config.pass
    endpoint = Escenic::API::Config.endpoint
    id = '51'

    it "should get a section's information  successfully" do
      stub_request(:get, "http://mockuser:mockpass@www.example.com/section/:id?").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})
      @client.section(:get, { id: id }).should be_an_instance_of(Net::HTTPOK)
    end
  end


end