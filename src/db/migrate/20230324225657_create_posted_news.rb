require 'active_record'

class CreatePostedNews < ActiveRecord::Migration[7.0]
  def up
    create_table :posted_news do |t|
      t.string :title
      t.string :link
      t.datetime :posted_at
    end
  end

  def down
    drop_table :posted_news
  end
end
