class CreateDownvotes < ActiveRecord::Migration
  def change
    create_table :downvotes do |t|
      t.integer     :user_id
      t.integer     :downvotable_id
      t.string      :downvotable_type

      t.timestamps null: false
    end
  end
end
