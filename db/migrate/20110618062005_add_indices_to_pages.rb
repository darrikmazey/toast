class AddIndicesToPages < ActiveRecord::Migration
  def self.up
		add_index :pages, [:scraper_id], :name => 'scraper_id_index'
		add_index :pages, [:scrape_started_at, :scrape_ended_at], :name => 'scrape_times_index'
  end

  def self.down
		remove_index :pages, :scraper_id_index
		remove_index :pages, :scrape_times_index
  end
end
