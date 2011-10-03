class AddLangToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :lang, :string
  end

  def self.down
    remove_column :users, :lang
  end
end
