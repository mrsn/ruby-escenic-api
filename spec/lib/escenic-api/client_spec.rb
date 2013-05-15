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

    #it 'returns a Escenic::API::Section if given a name, unique_name, directory parameter and parent info' do
    #  stub_request(:post, "http://mockuser:mockpass@www.example.com/webservice/escenic/section?").
    #      with(:body => "<?xml version=\"1.0\"?>\n<entry xmlns=\"http://www.w3.org/2005/Atom\" xmlns:app=\"http://www.w3.org/2007/app\" xmlns:metadata=\"http://xmlns.escenic.com/2010/atom-metadata\" xmlns:dcterms=\"http://purl.org/dc/terms/\">\n  <link rel=\"http://www.vizrt.com/types/relation/parent\" href=\"http://www.example.com/webservice/escenic/section/76\" title=\"Home\" type=\"application/atom+xml; type=entry\"/>\n  <content type=\"application/vnd.vizrt.payload+xml\">\n    <vdf:payload xmlns:vdf=\"http://www.vizrt.com/types\" model=\"http://www.example.com/webservice/publication/publication/escenic/model/com.escenic.section\">\n      <vdf:field name=\"com.escenic.sectionName\">\n        <vdf:value>name</vdf:value>\n      </vdf:field>\n      <vdf:field name=\"com.escenic.uniqueName\">\n        <vdf:value>unique_name</vdf:value>\n      </vdf:field>\n      <vdf:field name=\"com.escenic.directoryName\">\n        <vdf:value>directory</vdf:value>\n      </vdf:field>\n    </vdf:payload>\n  </content>\n</entry>\n",
    #           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/atom+xml', 'User-Agent'=>'Ruby'}).
    #      to_return(
    #        :status => 201,
    #        :body => "",
    #        :headers => {
    #            :server=>"Apache-Coyote/1.1",
    #            :location=>"http://localhost:8080/webservice/escenic/section/51",
    #            :content_type=>"application/xml",
    #            :content_length=>"0",
    #            :date=>"Tue, 14 May 2013 14:36:55 GMT"
    #        }
    #  )
    #
    #  Escenic::API::Raw.new( { id: '51' }, @client).get_section.stub(GET_SECTION_XML)
    #
    #  section = @client.section(
    #      name: 'name',
    #      unique_name: 'unique_name',
    #      directory: 'directory',
    #      parent_id: 76,
    #      parent_title: 'Home'
    #  )
    #  section.should be_an_instance_of(Escenic::API::Section)
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