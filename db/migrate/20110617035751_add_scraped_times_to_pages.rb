class AddScrapedTimesToPages < ActiveRecord::Migration
  def self.up
		add_column :pages, :scrape_started_at, :datetime
		add_column :pages, :scrape_ended_at, :datetime
  end

  def self.down
		remove_column :pages, :scrape_ended_at
		remove_column :pages, :scrape_started_at
  end
end
