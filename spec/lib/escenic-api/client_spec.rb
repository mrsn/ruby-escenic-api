require 'spec_helper'

describe Escenic::API::Client do

  before do
    @time    = Time.now.to_i
    @client  = Escenic::API::client
    @section = @client.section(
        sectionName:   "new section #{@time}",
        uniqueName:    "new_section_#{@time}",
        directoryName: "new_section_#{@time}"
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
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a name parameter' do
      lambda do
        @client.section(name: 'name')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a unique_name parameter' do
      lambda do
        @client.section(unique_name: 'unique_name')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a directory parameter' do
      lambda do
        @client.section(directory: 'directoryname')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a name and directory parameter' do
      lambda do
        @client.section(name: 'name', directory: 'directory')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a unique_name and directory parameter' do
      lambda do
        @client.section(unique_name: 'unique_name', directory: 'directory')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Error::Params if only given a name and unique_name parameter' do
      lambda do
        @client.section(name: 'name', unique_name: 'unique_name')
      end.should raise_error(Escenic::API::Error::Params)
    end

    it 'returns a Escenic::API::Section if given only a id parameter' do
      id      = @section.content.entry.identifier
      section = @client.section(id: id)
      section.should be_an_instance_of(Escenic::API::Section)
    end

    it 'returns an Net::HTTPNoContent when a section is deleted' do
      section = @client.section(
          sectionName:   "delete section test #{@time}",
          uniqueName:    "delete_section_test_#{@time}",
          directoryName: "delete_section_test_#{@time}"
      )
      section.delete?.should equal(true)
    end

    it 'returns a Escenic::API::Section if given a name, unique_name, directory parameter' do
      section = @client.section(
          sectionName:   "create section #{@time}",
          uniqueName:    "create_section_#{@time}",
          directoryName: "create_section_#{@time}"
      )
      section.should be_an_instance_of(Escenic::API::Section)
    end

    it 'returns true when a section is updated' do
      section = @client.section(
          sectionName:   "update section test #{@time}",
          uniqueName:    "update_section_test_#{@time}",
          directoryName: "update_section_test_#{@time}"
      )
      section.update('sectionName' => "this name changed #{@time}").should be_an_instance_of(Escenic::API::Section)
    end

  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      @client.root.should be_an_instance_of(Escenic::API::Root)
    end
  end

  after do
    @section.delete?
  end

end