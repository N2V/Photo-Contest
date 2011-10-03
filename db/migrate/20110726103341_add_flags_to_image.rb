class AddFlagsToImage < ActiveRecord::Migration
  def self.up
     add_column :images, :flags, :integer, :null=> false,:default=>0
  end

  def self.down
    remove_column :images, :flags
  end
end
