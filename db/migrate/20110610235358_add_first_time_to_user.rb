class AddFirstTimeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_time, :boolean,:null=>false,:default=> 1
  end

  def self.down
    remove_column :users, :first_time
  end
end
