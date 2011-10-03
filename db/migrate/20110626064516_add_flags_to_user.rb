class AddFlagsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :flags, :integer, :null=> false,:default=>0
  end

  def self.down
    remove_column :users, :flags
  end
end
