class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :image_file, :null=>false
      t.integer :contest_id,:null=>false
      t.integer :user_id, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
