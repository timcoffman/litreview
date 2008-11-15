class CreateReasons < ActiveRecord::Migration
  def self.up
    create_table :reasons do |t|
      t.integer :review_stage_id
      t.integer :created_by_stage_reviewer_id, :null => :true
      t.string :title
      t.integer :sequence
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reasons
  end
end
