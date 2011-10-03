class ChangeContestCustomerNameToAppName < ActiveRecord::Migration
  def self.up
    add_column :contests, :application_name, :string
    remove_column :contests, :customer_name
  end

  def self.down
  end
end
