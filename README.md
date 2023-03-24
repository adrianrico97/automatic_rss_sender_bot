# Automatic RSS sender bot
This bot read posts from an RSS source and sends them to a Telegram channel. It uses an SQLite database to save the sent posts.

## Config

In `config` folder you will find two files:
* `database.yml`: Database configuration
* `config.yml`: Bot configuration. This file is in the `.gitignore`. You can follow the `config.yml.sample` to create it.

## Usage

* Run `ruby bin/migrate.rb` to create and update the database.
* Run `ruby bin/console.rb` to start a console.
* Run `ruby bin/rss_sender.rb` to check and send the last news from the RSS source to the Telegram channel. You can add this command to `crontab` to automatically send the last news.

## Pending items
* Review the code structure
* Support multiple URLs and multiple channels
