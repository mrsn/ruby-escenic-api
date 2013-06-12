require_relative '../../spec_helper'

describe Escenic::API::Client do


  before do
    @time    = Time.now.to_i
    @client  = Escenic::API::client
  end

  describe '#raw' do
    it 'should be an instance of Escenic::API::Raw' do
      conn = @client.raw
      conn.should be_an_instance_of(Escenic::API::Raw)
    end
  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      @client.root.should be_an_instance_of(Escenic::API::Root)
    end
  end

end