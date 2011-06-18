class AddMorePostingsIndices < ActiveRecord::Migration
  def self.up
		add_index :postings, [:scraper_id], :name => 'scraper_id_index'
		add_index :postings, [:loaded], :name => 'loaded_index'
		add_index :postings, [:posted_at], :name => 'posted_at_index'
		add_index :postings, [:url], :name => 'url_index'
  end

  def self.down
		remove_index :postings, :url_index
		remove_index :postings, :posted_at_index
		remove_index :postings, :loaded_index
		remove_index :postings, :scraper_id_index
  end
end
