class AddNewFlagToPostings < ActiveRecord::Migration
  def self.up
		add_column :postings, :new, :boolean, :default => true
		add_index :postings, [:new], :name => 'new_index'
  end

  def self.down
		remove_index :postings, :new_index
		remove_column :postings, :new
  end
end
