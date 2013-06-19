require_relative '../../spec_helper'

describe Escenic::API::Spec do
  it 'returns a specification for an person type' do
    spec = Escenic::API::Spec.for_id('com.escenic.person')
    spec.should be_an_instance_of(Escenic::API::Spec)
    spec.fields.length.should eq(11)
  end
  it 'returns validates a person payload' do
    spec = Escenic::API::Spec.for_id('com.escenic.person')
    person_options = {verb: :create, fields: {'com.escenic.firstName' => 'John', 'com.escenic.surName' => 'Doe'}}
    payload = Escenic::API::PersonPayload.new(person_options)
    spec.validate(payload)
  end
end
