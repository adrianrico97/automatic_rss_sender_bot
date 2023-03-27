require 'active_record'

class AddChannelIdentifierToPostedNews < ActiveRecord::Migration[7.0]
  def up
    add_column :posted_news, :channel_identifier, :string
  end

  def down
    remove_column :posted_news, :channel_identifier
  end
end
