require 'spec_helper'

describe Escenic::API::Connection do

  before do
    @connection = Escenic::API::Connection.new
  end

  describe "#request" do

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

    304.upto(399) do |code|
      it "returns a Escenic::API::Error::Redirect when the response is #{code}" do
        body = mock :code => code, :body => 'I am a string'
        lambda do
          @connection.request { body }
        end.should raise_error( Escenic::API::Error::Redirect )
      end
    end

    500.upto(599) do |code|
      it "returns a Escenic::API::Error::ServerError when the response is #{code}" do
        body = mock :code => code, :body => 'I am a string'
        lambda do
          @connection.request { body }
        end.should raise_error( Escenic::API::Error::ServerError )
      end
    end

  end

end