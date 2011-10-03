class AddFlagsToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :flags, :integer, :null=> false,:default=>0
  end

  def self.down
  end
end
