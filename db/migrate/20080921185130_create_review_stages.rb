class CreateReviewStages < ActiveRecord::Migration
  def self.up
    create_table :review_stages do |t|
      t.integer :project_id
	  t.integer :sequence
      t.string :name
      t.text :description
      t.string :gate_function

      t.timestamps
    end
  end

  def self.down
    drop_table :review_stages
  end
end
