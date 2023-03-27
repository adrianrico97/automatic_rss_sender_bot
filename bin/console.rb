require 'irb'
require 'active_record'
require_relative '../app/models/posted_new'
require 'yaml'

# Load the database configuration
database_config_path = File.join(__dir__, '..', 'config', 'database.yml')
database = YAML.load_file(database_config_path)

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Abrir la consola de Ruby
IRB.start
