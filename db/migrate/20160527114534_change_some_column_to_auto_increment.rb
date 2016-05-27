class ChangeSomeColumnToAutoIncrement < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE upvotes modify COLUMN id int(8) AUTO_INCREMENT"
    execute "ALTER TABLE downvotes modify COLUMN id int(8) AUTO_INCREMENT"
  end

  def self.down
    execute "ALTER TABLE upvotes modify COLUMN id int(8)"
    execute "ALTER TABLE downvotes modify COLUMN id int(8)"
  end

end
