class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer   :user_id
      t.string    :full_name
      t.text      :bio
      t.date      :birthday
      t.text      :title
      t.integer   :points
      t.string    :fb_link
      t.string    :photo
      t.string    :mobile

      t.timestamps null: false
    end
  end
end
