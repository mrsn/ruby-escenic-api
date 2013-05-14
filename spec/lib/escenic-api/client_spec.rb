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
    it 'should be an instance of Escenic::API::Section' do
      stub_request(:get, "http://mockuser:mockpass@www.example.com/section/:id?").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => SECTION_XML, :headers => {})
      @client.section( { id: '102' } )
    end
  end

end