require 'yaml'

GET_ROOT_XML        = File.new 'spec/xml/get_root.xml', 'r'
GET_SECTION_XML     = File.new 'spec/xml/get_section.xml', 'r'
CREATE_SECTION_XML  = File.new 'spec/xml/create_section.xml', 'r'

config = YAML.load_file 'spec/connection.yml'
Escenic::API::Config.base_url     = config['base_url']
Escenic::API::Config.user         = config['user']
Escenic::API::Config.pass         = config['pass']
Escenic::API::Config.publication  = config['publication']