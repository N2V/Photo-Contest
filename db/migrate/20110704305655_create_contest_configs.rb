class CreateContestConfigs < ActiveRecord::Migration
  def self.up
    create_table(:contest_configs) do |t|
      t.integer :contest_id
      t.string :lang
      t.text :welcome_note
      t.text  :prizes
      t.text  :entry_format
      t.text  :inappropriate_content
      t.text  :winners
      t.text  :upload_hint
      t.text  :email_body
      t.timestamps
    end
    
    add_index :contest_configs, [:contest_id,:lang], :unique => true
  end

  def self.down
  end
end
