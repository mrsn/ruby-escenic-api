require 'spec_helper'

describe Escenic::API::Client do

  before do
    @client = Escenic::API::Client.new
  end

  describe '#raw' do
    it 'should be an instance of Escenic::API::Raw' do
      conn = @client.instance_variable_get(:@raw)
      conn.should be_an_instance_of(Escenic::API::Raw)
    end
  end

  describe '#section' do
    it 'returns a Escenic::API::Error if given no parameters' do
      lambda do
        @client.section
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a name parameter' do
      lambda do
        @client.section(name: 'name')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a unique_name parameter' do
      lambda do
        @client.section(unique_name: 'unique_name')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a directory parameter' do
      lambda do
        @client.section(directory: 'directoryname')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a name and directory parameter' do
      lambda do
        @client.section(name: 'name', directory: 'directory')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a unique_name and directory parameter' do
      lambda do
        @client.section(unique_name: 'unique_name', directory: 'directory')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Error::Params if only given a name and unique_name parameter' do
      lambda do
        @client.section(name: 'name', unique_name: 'unique_name')
      end.should raise_error( Escenic::API::Error::Params )
    end

    it 'returns a Escenic::API::Section if given only a id parameter' do
      stub_request(:get, 'http://mockuser:mockpass@www.example.com/webservice/escenic/section/51?').
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => GET_SECTION_XML, :headers => {})

      section = @client.section(id: '51')
      section.should be_an_instance_of( Escenic::API::Section )
    end


    #pending
    #it 'returns a Escenic::API::Section if given a name, unique_name, and directory parameter' do
    #  stub_request(:post, 'http://mockuser:mockpass@www.example.com/webservice/escenic/section?').
    #      with(:headers => {'Accept'=>'*/*', 'Content-Type'=>'application/atom+xml', 'User-Agent'=>'Ruby'}).
    #      to_return(:status => 200, :body => '', :headers => {})
    #
    #  section = @client.section(
    #      name: 'name',
    #      unique_name: 'unique_name',
    #      directory: 'directory'
    #  )
    #  section.should be_an_instance_of( Escenic::API::Section )
    #end


  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      stub_request(:get, "http://mockuser:mockpass@www.example.com/webservice/escenic/section/ROOT/subsections?").
          with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => GET_ROOT_XML, :headers => {})
      @client.root_section.should be_an_instance_of( Escenic::API::Object )
    end
  end


end