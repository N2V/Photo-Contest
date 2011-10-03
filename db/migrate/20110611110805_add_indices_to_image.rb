class AddIndicesToImage < ActiveRecord::Migration
  def self.up
    add_index "images", ["user_id"], :name => "index_images_on_user_id"
    add_index "images", ["contest_id"], :name => "index_images_on_contest_id"
  end

  def self.down
  end
end
