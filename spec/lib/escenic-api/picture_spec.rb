require_relative '../../spec_helper'

describe Escenic::API::Picture do


  before do
    @time       = Time.now.to_i
    @client     = Escenic::API::client
    @section_id = Escenic::API::Section.create(
        fields: {
            'com.escenic.sectionName'   => "new section #{@time}",
            'com.escenic.uniqueName'    => "new_section_#{@time}",
            'com.escenic.directoryName' => "new_section_#{@time}"
        }
    ).id
  end


  it 'returns an Escenic::API::Picture if given title and filename' do
    picture = Escenic::API::Picture.create(
        title:    'Create Content Item Spec Test',
        filename: 'spec/images/test.jpg',
    )
    picture.should be_an_instance_of(Escenic::API::Picture)
    picture.content.entry.title.should eq('test.jpg')
  end

  it 'returns an Escenic::API::Picture if given title and filename' do
    picture = Escenic::API::Picture.create(
        title:    'Create Content Item Spec Test',
        filename: 'spec/images/test.jpg',
    )
    picture.should be_an_instance_of(Escenic::API::Picture)
    picture = picture.update(fields: {caption: 'a new caption'})

    fields = picture.content.entry.content.payload.field
    pass   = false
    fields.each do |field|
      if field.length > 1
        if field.attributes.name.include?('caption')
          field.value.should eq('a new caption')
          pass = true
        end
      end
    end
    fail "couldn't find field caption" if !pass

  end

  after do
    Escenic::API::Section.for_id(@section_id).delete?
  end
end