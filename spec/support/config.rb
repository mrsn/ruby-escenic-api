require 'yaml'

section_xml = ERB.new File.new("spec/erb/section_xml.erb").read, nil, "%"
SECTION_XML = section_xml.result(binding)

config = YAML.load_file 'spec/connection.yml'
Escenic::API::Config.endpoint     = config['endpoint']
Escenic::API::Config.user         = config['user']
Escenic::API::Config.pass         = config['pass']
Escenic::API::Config.publication  = config['publication']