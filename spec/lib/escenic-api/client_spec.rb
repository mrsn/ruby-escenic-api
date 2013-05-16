require 'spec_helper'

describe Escenic::API::Client do

  before do
    @random = rand(9999999999)
    @client = Escenic::API::Client.new
    @section = @client.section(
        sectionName: "new section #{@random}",
        uniqueName: "new_section_#{@random}",
        directoryName: "new_section_#{@random}"
    )
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
      id = @section.entry.identifier
      section = @client.section(id: id)
      section.should be_an_instance_of( Escenic::API::Section )
    end

    it 'returns a Escenic::API::Section if given a name, unique_name, directory parameter' do
      section = @client.section(
          sectionName: "rspec section #{@random}",
          uniqueName: "rspec_section_#{@random}",
          directoryName: "rspec_section_#{@random}"
      )
      section.should be_an_instance_of(Escenic::API::Section)
    end

    it 'returns an Net::HTTPNoContent when a section is deleted' do
      section = @client.section(
          sectionName: "delete section test #{@random}",
          uniqueName: "delete_section_test_#{@random}",
          directoryName: "delete_section_test_#{@random}"
      )

      section.delete.should be_an_instance_of(Net::HTTPNoContent)

    end

  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      @client.root_section.should be_an_instance_of( Escenic::API::Object )
    end
  end


end