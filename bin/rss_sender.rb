require 'active_record'
require 'yaml'
require_relative '../lib/bot'

database_config_path = File.join(__dir__, '..', 'config', 'database.yml')
database = YAML.load_file(database_config_path)

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Ejecuta el bot
puts "Start: #{Time.now}"
post_news
puts "End: #{Time.now}"
