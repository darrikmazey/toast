class AddPostingIndexOnPageId < ActiveRecord::Migration
  def self.up
		add_index :postings, [:page_id], :name => 'page_id_index'
  end

  def self.down
		remove_index :postings, :page_id_index
  end
end
