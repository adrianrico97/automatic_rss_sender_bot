# Automatic RSS sender bot
This bot read posts from an RSS source and sends them to a Telegram channel. It uses an SQLite database to save the sent posts.

## Config

In `config` folder you will find two files:
* `database.yml`: Database configuration
* `config.yml`: Bot configuration. This file is in the `.gitignore`. You can follow the `config.yml.sample` to create it.

### Config.yml fields

| Field name | Description |
|------------|-------------|
|bot_token   | Bot's token. You can get it asking to @BotFather|
|channel_id  | Channel ID. If the channel is public the ID is the @name. If the channel is private you can use the JsonDumpBot to get the ID.|
|rss_feed_url| URL of the RSS feed (where you want to read the news).|

## Usage

* Run `ruby bin/migrate.rb` to create and update the database.
* Run `ruby bin/console.rb` to start a console.
* Run `ruby bin/rss_sender.rb` to check and send the last news from the RSS source to the Telegram channel. You can add this command to `crontab` to automatically send the last news.

## Installation

```bash
# Install gems
bundle install

# Run migrations
ruby bin/migrate.rb

# Run bot
./scripts/start_rss_sender
```

## Tag versions
```bash
# Create a tag version
git tag -a version-YYYYMMDD-vX.Y -m 'Version X.Y'

# Push tags
git push origin --tags
```

## Pending items
* Review the code structure
* Improve log
