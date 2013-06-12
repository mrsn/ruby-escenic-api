require_relative '../../spec_helper'

describe Escenic::API::Spec do
  it 'returns a specification for an person type' do
    spec = Escenic::API::Spec.for_id('com.escenic.person')
    spec.should be_an_instance_of(Escenic::API::Spec)
    spec.fields.length.should eq(11)
  end
end
