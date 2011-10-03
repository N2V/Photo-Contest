class DropActiveColumnFromContest < ActiveRecord::Migration
  def self.up
    remove_column :contests, :active
  end

  def self.down
  end
end
