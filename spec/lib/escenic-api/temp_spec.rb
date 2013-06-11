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


  describe '#person' do

    it 'returns true when a person is updated' do
      person = @client.person(
          firstName: 'John',
          surName:   'Doe'
      )
      person = person.update(
          postalCode: '00001'
      )
      person.should be_an_instance_of(Escenic::API::Person)
      fields = person.content.entry.content.payload.field
      pass   = false
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

  end
  after do
    @section.delete?
  end

end