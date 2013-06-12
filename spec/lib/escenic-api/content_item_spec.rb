require 'spec_helper'

describe Escenic::API::ContentItem do


  before do
    @time    = Time.now.to_i
    @client  = Escenic::API::client
    @section_id = Escenic::API::Section.create(
        sectionName:   "new section #{@time}",
        uniqueName:    "new_section_#{@time}",
        directoryName: "new_section_#{@time}"
    ).id
  end

  describe '#content_item' do
    it 'returns an Escenic::API::ContentItem if given title and type' do
      Escenic::API::ContentItem.create(
          title: 'Create Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          section_id: @section_id
      ).should be_an_instance_of(Escenic::API::ContentItem)
    end

    it 'returns true when a content item is updated' do

      content_item = Escenic::API::ContentItem.create(
          title: 'Update Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          description: 'description',
          section_id: @section_id
      )
      content_item.update(
          body: "this body has been updated #{@time}",
          description: "description update #{@time}"
      ).should be_an_instance_of(Escenic::API::ContentItem)
    end

    it 'returns true when a content item is deleted' do
      content_item = Escenic::API::ContentItem.create(
          title: 'Delete Content Item Spec Test',
          type: 'Event',
          body: 'blah blah body blah blah',
          section_id: @section_id
      )
      content_item.delete?.should equal(true)
    end

  end
  
  after do
    Escenic::API::Section.for_id(@section_id).delete?
  end

end