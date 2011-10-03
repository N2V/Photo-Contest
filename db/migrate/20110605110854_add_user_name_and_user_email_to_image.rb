class AddUserNameAndUserEmailToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :user_name, :string,:null=> false
    add_column :images, :user_email, :string,:null=> false
  end

  def self.down
    remove_column :images, :user_email
    remove_column :images, :user_name
  end
end
