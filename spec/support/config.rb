require 'yaml'

GET_ROOT_XML        = File.new 'spec/erb/get_root.xml', 'r'
GET_SECTION_XML     = File.new 'spec/erb/get_section.xml', 'r'
CREATE_SECTION_XML  = File.new 'spec/erb/create_section.xml', 'r'

config = YAML.load_file 'spec/connection.yml'
Escenic::API::Config.endpoint     = config['endpoint']
Escenic::API::Config.user         = config['user']
Escenic::API::Config.pass         = config['pass']
Escenic::API::Config.publication  = config['publication']