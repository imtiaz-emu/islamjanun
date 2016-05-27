class CreateUpvotes < ActiveRecord::Migration
  def change
    create_table :upvotes do |t|
      t.integer     :user_id
      t.integer     :upvotable_id
      t.string      :upvotable_type

      t.timestamps null: false
    end
  end
end
