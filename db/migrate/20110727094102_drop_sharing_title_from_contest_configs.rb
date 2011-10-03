class DropSharingTitleFromContestConfigs < ActiveRecord::Migration
  def self.up
    remove_column :contest_configs, :sharing_title
  end

  def self.down
  end
end
