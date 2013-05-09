require 'yaml'

config = YAML.load_file 'spec/connection.yml'

Escenic::API::Config.endpoint     = config['endpoint']
Escenic::API::Config.user         = config['user']
Escenic::API::Config.pass         = config['pass']
Escenic::API::Config.publication  = config['publication']
