class AddUserIdToContests < ActiveRecord::Migration
  def self.up
    add_column :contests, :user_id, :integer,:null=>false
  end

  def self.down
    remove_column :contests, :user_id
  end
end
