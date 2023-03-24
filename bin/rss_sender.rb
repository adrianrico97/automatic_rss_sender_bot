require 'active_record'
require 'yaml'
require_relative '../lib/bot'

database = YAML.load_file('config/database.yml')

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Ejecuta el bot
post_news
