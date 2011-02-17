class CreateObservations < ActiveRecord::Migration
  def self.up
    create_table :observations do |t|
      t.text :location, :null => false
      t.text :description, :null => false
      t.integer :criticality, :default => 3
      t.string :classification, :default => 'bug'
      t.string :status, :default => 'new'

      t.timestamps
    end
  end

  def self.down
    drop_table :observations
  end
end
