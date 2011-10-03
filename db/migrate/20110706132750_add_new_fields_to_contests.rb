class AddNewFieldsToContests < ActiveRecord::Migration
  def self.up
    add_column :contests, :customer_name, :string
    add_column :contests, :notifications_email, :string
    add_column :contests, :notifications_bcc_emails, :string
  end

  def self.down
    remove_column :contests, :bcc_emails
    remove_column :contests, :notifications_email
    remove_column :contests, :customer_name
  end
end
