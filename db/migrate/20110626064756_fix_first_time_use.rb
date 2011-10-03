class FixFirstTimeUse < ActiveRecord::Migration
  def self.up
    # update attributes
    User.all.each do |user|
      if not user.first_time?
        user.used_before = true
        user.save
      end
    end
    # remove first_time column
    remove_column :users, :first_time 
  end

  def self.down
  end
end
