require 'active_record'
require 'yaml'

database = YAML.load_file('config/database.yml')

# Establecer la conexión a la base de datos
ActiveRecord::Base.establish_connection(database["default"])

# Obtener todas las migraciones pendientes
pending_migrations = ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).pending_migration_versions

# Ejecutar las migraciones pendientes
if pending_migrations.any?
  ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).migrate
  puts "Migraciones ejecutadas con éxito"
else
  puts "No hay migraciones pendientes"
end
