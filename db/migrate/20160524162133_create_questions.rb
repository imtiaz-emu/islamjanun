class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer     :user_id
      t.text        :description, :limit => 16.megabytes - 1
      t.text        :title

      t.timestamps null: false
    end
  end
end
