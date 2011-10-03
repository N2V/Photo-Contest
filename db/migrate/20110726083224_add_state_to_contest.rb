class AddStateToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :state, :string
    Contest.all.each{|c|c.update_attribute :state,'live'}
  end

  def self.down
    remove_column :contests, :state
  end
end
