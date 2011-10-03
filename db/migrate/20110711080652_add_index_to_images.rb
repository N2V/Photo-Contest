class AddIndexToImages < ActiveRecord::Migration
  def self.up
    add_index "images", ["contest_id","user_id"], :name => "index_images_on_contest_id_and_user_id"
  end

  def self.down
  end
end
