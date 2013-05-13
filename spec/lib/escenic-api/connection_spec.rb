require 'spec_helper'

describe Escenic::API::Connection do

  before do
    @connection = Escenic::API::Connection.new
  end

  describe "#user" do
    it 'should match Escenic::API::Config.user' do
      @connection.instance_variable_get(:@user).should equal(Escenic::API::Config.user)
    end
  end

  describe "#pass" do
    it 'should match Escenic::API::Config.pass' do
      @connection.instance_variable_get(:@pass).should equal(Escenic::API::Config.pass)
    end
  end

  describe "#endpoint" do
    it 'should match Escenic::API::Config.endpoint' do
      @connection.instance_variable_get(:@endpoint).should equal(Escenic::API::Config.endpoint)
    end
  end

  describe "#request" do

    it 'returns a parsed response when the response is a 200' do
      body = mock :code => 200, :body => 'I am a string'
      response = @connection.request { body }
      response.should be_an_instance_of( String )
    end

    it 'returns a parsed response when the response is a 201' do
      body = mock :code => 201, :body => 'I am a string'
      response = @connection.request { body }
      response.should be_an_instance_of( String )
    end

    it 'returns a parsed response when the response is a 204' do
      body = mock :code => 204, :body => 'I am a string'
      response = @connection.request { body }
      response.should be_an_instance_of( String )
    end

    it 'returns a Escenic::API::Error::Unauthorized when the response is 401' do
      body = mock :code => 401, :body => 'I am a string'
      lambda do
        @connection.request { body }
      end.should raise_error( Escenic::API::Error::Unauthorized )
    end

    it 'returns a Escenic::API::Error::Forbidden when the response is 403' do
      body = mock :code => 403, :body => 'I am a string'
      lambda do
        @connection.request { body }
      end.should raise_error( Escenic::API::Error::Forbidden )
    end

    it 'returns a Escenic::API::Error::NotFound when the response is 404' do
      body = mock :code => 404, :body => 'I am a string'
      lambda do
        @connection.request { body }
      end.should raise_error( Escenic::API::Error::NotFound )
    end

    [400, 406].each do |code|
      it "returns a Escenic::API::Error when the response is #{code}" do
        body = mock :code => code, :body => 'I am a string'
        lambda do
          @connection.request { body }
        end.should raise_error( Escenic::API::Error )
      end
    end

    300.upto(399) do |code|
      it "returns a Escenic::API::Error::Redirect when the response is #{code}" do
        body = mock :code => code, :body => 'I am a string'
        lambda do
          @connection.request { body }
        end.should raise_error( Escenic::API::Error::Redirect )
      end
    end

    500.upto(599) do |code|
      it "returns a Escenic::API::Error when the response is #{code}" do
        body = mock :code => code, :body => 'I am a string'
        lambda do
          @connection.request { body }
        end.should raise_error( Escenic::API::Error )
      end
    end

  end

end