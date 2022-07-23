class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :customer_id
      t.string :name,              null: false, default: ""
      t.string :description,              null: false, default: ""
      t.timestamps
    end
  end
end
