class AddPrizesNumToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :prizes_num, :integer,:null=>false,:default=>1
  end

  def self.down
    remove_column :contests, :prizes_num
  end
end
