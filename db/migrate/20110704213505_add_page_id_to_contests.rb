class AddPageIdToContests < ActiveRecord::Migration
  def self.up
    add_column :contests, :page_id, :string,:null=>false
  end

  def self.down
    remove_column :contests, :page_id
  end
end
