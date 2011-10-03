class AddingLanguagesToContest < ActiveRecord::Migration
  def self.up
     add_column :contests, :languages, :integer, :null=> false,:default=>1
  end

  def self.down
  end
end
