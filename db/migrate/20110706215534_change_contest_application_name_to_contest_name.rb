class ChangeContestApplicationNameToContestName < ActiveRecord::Migration
  def self.up
    remove_column :contests, :application_name
  end

  def self.down
  end
end
