class RenameFieldsOfCotestConfigs < ActiveRecord::Migration
  def self.up
    rename_column :contest_configs,:sharing_description,:description
    rename_column :contest_configs,:winners,:winning_eligibility
  end

  def self.down
  end
end
