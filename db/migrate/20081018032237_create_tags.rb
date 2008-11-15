class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :words
      t.integer :created_by_user_id
      t.integer :created_for_project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
