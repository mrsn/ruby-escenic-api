require_relative '../../spec_helper'

describe Escenic::API::Client do
  describe '#person' do
    it 'returns an Escenic::API::Person if given surname' do
      person = Escenic::API::Person.create(
          firstName: 'John',
          surName:   'Doe'
      )
      person.should be_an_instance_of(Escenic::API::Person)
    end

    it 'returns true when a person is updated' do
      person = Escenic::API::Person.create(
          firstName: 'John',
          surName:   'Doe'
      )
      person.should be_an_instance_of(Escenic::API::Person)
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

    it 'returns true when a person is deleted' do
      person = Escenic::API::Person.create(
          firstName: 'John',
          surName:   'Doe'
      )
      person.delete?.should equal(true)
    end
  end
end