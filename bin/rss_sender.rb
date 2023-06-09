require 'active_record'
require 'yaml'
require_relative '../lib/bot'

# Establecer la conexión a la base de datos
database_config_path = File.join(__dir__, '..', 'config', 'database.yml')
database = YAML.load_file(database_config_path)
ActiveRecord::Base.establish_connection(database["default"])

# Load the configuration
config_path = File.join(__dir__, '..', 'config', 'config.yml')
config = Hash[YAML.load_file(config_path).map{ |k, v| [k.to_sym, v] }]

# Ejecuta el bot
puts "Start: #{Time.now}"
config[:feeds].each do |feed|
  puts "Reading from #{feed["rss_feed_url"]}"
  result = {}
  retry_count = 0
  while !result["ok"] && retry_count < 5
    retry_count += 1
    result = Bot.new(
      config[:bot_token],
      feed["channel_id"],
      feed["rss_feed_url"]
    ).post_news
    if !result["ok"] && result["error_code"] == 429 # Too Many Requests
      puts "Trying again in #{result["parameters"]["retry_after"]} seconds. Retry counter: #{retry_count}"
      sleep result["parameters"]["retry_after"]
    elsif !result["ok"]
      puts "ERROR CODE: #{result["error_code"]}. Retry counter: #{retry_count}"
    end
  end
end
puts "End: #{Time.now}"
