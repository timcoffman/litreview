class AddKeywordsToProject < ActiveRecord::Migration
  def self.up
	add_column :projects, :keywords, :string, :null => true, :limit => 1024
  end

  def self.down
	remove_column :projects, :keywords
  end
end
