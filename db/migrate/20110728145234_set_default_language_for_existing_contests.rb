class SetDefaultLanguageForExistingContests < ActiveRecord::Migration
  def self.up
    Contest.all.each{|c| c.default_language='ar';c.arabic=true;c.english=true;c.save;}
  end

  def self.down
  end
end