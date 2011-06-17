class AddFoundAtToPages < ActiveRecord::Migration
  def self.up
		add_column :pages, :found_at, :datetime
  end

  def self.down
		remove_column :pages, :found_at
  end
end
