class AddIgnoredColumnToPostings < ActiveRecord::Migration
  def self.up
		add_column :postings, :ignored, :boolean, :default => false
		add_index :postings, [:ignored], :name => 'ignored_index'
  end

  def self.down
		remove_index :postings, :ignored_index
		remove_column :postings, :ignored
  end
end
