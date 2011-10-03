class AddingDefaultLanguageToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :default_language, :string, :null=> false,:default=>'en'
  end

  def self.down
  end
end
