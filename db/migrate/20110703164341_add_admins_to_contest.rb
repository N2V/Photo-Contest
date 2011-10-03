class AddAdminsToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :admins, :text,:null=>false
  end

  def self.down
    remove_column :contests, :admins
  end
end
