require_relative '../../spec_helper'

describe Escenic::API::Section do

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

  it 'returns a Escenic::API::Error if given no parameters' do
    lambda do
      Escenic::API::Section.create
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a name parameter' do
    lambda do
      Escenic::API::Section.create(name: 'name')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a unique_name parameter' do
    lambda do
      Escenic::API::Section.create(unique_name: 'unique_name')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a directory parameter' do
    lambda do
      Escenic::API::Section.create(directory: 'directoryname')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a name and directory parameter' do
    lambda do
      Escenic::API::Section.create(name: 'name', directory: 'directory')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a unique_name and directory parameter' do
    lambda do
      Escenic::API::Section.create(unique_name: 'unique_name', directory: 'directory')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Error::Params if only given a name and unique_name parameter' do
    lambda do
      Escenic::API::Section.create(name: 'name', unique_name: 'unique_name')
    end.should raise_error(Escenic::API::Error::Params)
  end

  it 'returns a Escenic::API::Section if given only a id parameter' do

    section = Escenic::API::Section.for_id(@section_id)
    section.should be_an_instance_of(Escenic::API::Section)
  end

  it 'returns true when a section is deleted' do
    section = Escenic::API::Section.create(
        fields: {
            'com.escenic.sectionName'   => "delete section test #{@time}",
            'com.escenic.uniqueName'    => "delete_section_test#{@time}",
            'com.escenic.directoryName' => "delete_section_test#{@time}"
        }
    )
    section.delete?.should equal(true)
  end

  it 'returns a Escenic::API::Section if given a name, unique_name, directory parameter' do
    section = Escenic::API::Section.create(
        fields: {
            'com.escenic.sectionName'   => "create section test#{@time}",
            'com.escenic.uniqueName'    => "create_section_test#{@time}",
            'com.escenic.directoryName' => "create_section_test#{@time}"
        }
    )
    section.should be_an_instance_of(Escenic::API::Section)
    section.delete?
  end

  it 'returns Escenic::API::Section when a section is updated' do
    section = Escenic::API::Section.create(
        fields: {
            'com.escenic.sectionName'   => "update section test #{@time}",
            'com.escenic.uniqueName'    => "update_section_test#{@time}",
            'com.escenic.directoryName' => "update_section_test#{@time}"
        }
    )
    section.update('sectionName' => "this name changed #{@time}").should be_an_instance_of(Escenic::API::Section)
    section.delete?
  end

  it 'returns true when a section is updated with a new field' do
    section = Escenic::API::Section.create(
        fields: {
            'com.escenic.sectionName'     => "new field test #{@time}",
            'com.escenic.uniqueName'    => "new_field_test#{@time}",
            'com.escenic.directoryName' => "new_field_test#{@time}"
        }

    )
    section = section.update(
        fields: {
            new_field: "agreement info #{@time}",
        }
    )
    section.should be_an_instance_of(Escenic::API::Section)
    section.delete?
  end

  after do
    Escenic::API::Section.for_id(@section_id).delete?
  end
end