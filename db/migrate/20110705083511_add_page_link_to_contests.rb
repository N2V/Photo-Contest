class AddPageLinkToContests < ActiveRecord::Migration
  def self.up
    add_column :contests, :page_link, :text
  end

  def self.down
    remove_column :contests, :page_link
  end
end
