require 'irb'
require 'active_record'
require_relative '../app/models/posted_new'
require 'yaml'

database = YAML.load_file('config/database.yml')

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Abrir la consola de Ruby
IRB.start
