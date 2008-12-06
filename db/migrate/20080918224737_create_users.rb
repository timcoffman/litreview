class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :full_name
      t.string :nickname
      t.string :identity_url, :null => false
      t.string :email
      t.boolean :is_admin, :null => false, :default => false
      t.integer :current_project_id

      t.timestamps
    end
	add_index :users, :identity_url, :unique => true
	add_index :users, :nickname, :unique => true
  end

  def self.down
    drop_table :users
  end
end
