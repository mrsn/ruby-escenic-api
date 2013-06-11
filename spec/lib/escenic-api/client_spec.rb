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
      conn = @client.raw
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

    it 'returns true when a section is deleted' do
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

    it 'returns Escenic::API::Section when a section is updated' do
      section = @client.section(
          sectionName:   "update section test #{@time}",
          uniqueName:    "update_section_test_#{@time}",
          directoryName: "update_section_test_#{@time}"
      )
      section.update('sectionName' => "this name changed #{@time}").should be_an_instance_of(Escenic::API::Section)
    end

    it 'returns true when a section is updated with a new field' do
      section = @client.section(
          sectionName:    "new field test #{@time}",
          uniqueName:     "new_field_test_#{@time}",
          directoryName:  "new_field_test_#{@time}"
      )
      section.update(
          new_field: "agreement info #{@time}",
      ).should be_an_instance_of(Escenic::API::Section)
    end


  end

  describe '#root_section' do
    it 'returns a Escenic::API::Section' do
      @client.root.should be_an_instance_of(Escenic::API::Root)
    end
  end

  describe '#content_item' do
    it 'returns an Escenic::API::ContentItem if given title and type' do
      section_id = @section.content.entry.identifier
      @client.content_item(
          title: 'Create Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          section_id: section_id
      ).should be_an_instance_of(Escenic::API::ContentItem)
    end

    it 'returns true when a content item is updated' do
      section_id = @section.content.entry.identifier
      content_item = @client.content_item(
          title: 'Update Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          description: 'description',
          section_id: section_id
      )
      content_item.update(
          body: "this body has been updated #{@time}",
          description: "description update #{@time}"
      ).should be_an_instance_of(Escenic::API::ContentItem)
    end

    it 'returns true when a content item is deleted' do
      section_id = @section.content.entry.identifier
      content_item = @client.content_item(
          title: 'Delete Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          section_id: section_id
      )
      content_item.delete?.should equal(true)
    end

  end

  describe '#person' do
    it 'returns an Escenic::API::Person if given surname' do
      person = @client.person(
          firstName: 'John',
          surName: 'Doe'
      )
      person.should be_an_instance_of(Escenic::API::Person)
    end

    it 'returns true when a person is updated' do
      person = @client.person(
          firstName: 'John',
          surName: 'Doe'
      )
      person.should be_an_instance_of(Escenic::API::Person)
      person = person.update(
          postalCode: '00001'
      )
      person.should be_an_instance_of(Escenic::API::Person)
      fields = person.content.entry.content.payload.field
      pass = false
      fields.each do |field|
        if field.length > 1
          if field.attributes.name.include?('postalCode')
            field.value.should eq('00001')
            pass = true
          end
        end
      end
      fail "couldn't find field postalCode" if !pass
    end

    it 'returns true when a content item is deleted' do
      person = @client.person(
          firstName: 'John',
          surName: 'Doe'
      )
      person.delete?.should equal(true)
    end

  end
  after do
    @section.delete?
  end

end