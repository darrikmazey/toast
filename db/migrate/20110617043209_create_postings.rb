class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.references :scraper
      t.boolean :loaded
      t.string :url
      t.string :brief_content
      t.string :poster
      t.string :email
      t.datetime :posted_at
      t.text :long_content
      t.string :posting_id
      t.references :page

      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
