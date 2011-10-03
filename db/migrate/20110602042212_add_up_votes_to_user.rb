class AddUpVotesToUser < ActiveRecord::Migration
  def self.up
      add_column :users, :up_votes, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :integer
  end
end
