require 'active_record'
require 'yaml'
require_relative '../lib/bot'

database = YAML.load_file('config/database.yml')

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Ejecuta el bot
puts "Start: #{Time.now}"
post_news
puts "End: #{Time.now}"
