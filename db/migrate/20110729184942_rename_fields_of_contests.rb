class RenameFieldsOfContests < ActiveRecord::Migration
  def self.up
    rename_column :contests,:notifications_email,:notifications_sender_email
    rename_column :contests,:notifications_bcc_emails,:notifications_receivers_emails
  end

  def self.down
  end
end
