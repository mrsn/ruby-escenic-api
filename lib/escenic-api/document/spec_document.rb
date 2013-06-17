class SpecDocument < Nokogiri::XML::SAX::Document
  attr_reader :fields

  def initialize
    @fields      = []
    @field_props = []
  end

  def start_element_namespace(name, attrs=[], prefix=nil, uri=nil, ns=[])
    case name.to_sym
      when :fielddef
        @field_props.push proc_field_attributes(attrs)
    end
  end

  def end_element_namespace(name, prefix=nil, uri=nil, ns=[])
    case name.to_sym
      when :fielddef
        props                 = @field_props.pop
        @fields.push props[:name]
    end
  end

  def proc_field_attributes(attrs=[])
    prop_hash = {}
    attrs.each do |attr|
      prop_hash[attr[:localname].to_sym] = attr[:value]
    end
    prop_hash
  end
end