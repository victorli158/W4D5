class CreateGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.date :target_date, null: false
      t.integer :user_id, null: false
      t.boolean :public_goal, null: false, default: false
      t.timestamps
    end
    add_index :goals, :user_id
  end
end
