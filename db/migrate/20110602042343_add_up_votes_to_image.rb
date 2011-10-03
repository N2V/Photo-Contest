class AddUpVotesToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :up_votes, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :images, :integer
  end
end
