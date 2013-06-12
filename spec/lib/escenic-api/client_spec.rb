require_relative '../../spec_helper'

describe Escenic::API::Client do


  before do
    @client  = Escenic::API::client
  end

  describe '#raw' do
    it 'should be an instance of Escenic::API::Endpoints' do
      conn = @client.endpoints
      conn.should be_an_instance_of(Escenic::API::Endpoints)
    end
  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      @client.root.should be_an_instance_of(Escenic::API::Root)
    end
  end

end