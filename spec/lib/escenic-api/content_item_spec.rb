require_relative '../../spec_helper'

describe Escenic::API::ContentItem do


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


  it 'returns an Escenic::API::ContentItem if given title and type' do
    Escenic::API::ContentItem.create(
        type:       'Event',
        section_id: @section_id,
        title:      'Create Content Item Spec Test',
        fields:     {
            body: 'blah blah body blah blah',
        }
    ).should be_an_instance_of(Escenic::API::ContentItem)
  end

  it 'returns true when a content item is updated' do

    content_item = Escenic::API::ContentItem.create(
        type:       'Event',
        section_id: @section_id,
        title:      'Update Content Item Spec Test',
        fields:     {
            body:        'blah blah body blah blah',
            description: 'description',
        }
    )
    content_item.update(
        fields: {
            body:        "this body has been updated #{@time}",
            description: "description update #{@time}"
        }
    ).should be_an_instance_of(Escenic::API::ContentItem)
  end

  it 'returns true when a content item is deleted' do
    content_item = Escenic::API::ContentItem.create(
        type:       'Event',
        section_id: @section_id,
        title:      'Delete Content Item Spec Test',
        fields:     {
            body: 'blah blah body blah blah',
        }
    )
    content_item.delete?.should equal(true)
  end

  after do
    Escenic::API::Section.for_id(@section_id).delete?
  end

end