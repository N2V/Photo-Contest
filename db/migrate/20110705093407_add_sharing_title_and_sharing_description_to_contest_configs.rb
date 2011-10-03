class AddSharingTitleAndSharingDescriptionToContestConfigs < ActiveRecord::Migration
  def self.up
    add_column :contest_configs, :sharing_title, :text
    add_column :contest_configs, :sharing_description, :text
  end

  def self.down
    remove_column :contest_configs, :sharing_description
    remove_column :contest_configs, :sharing_title
  end
end
