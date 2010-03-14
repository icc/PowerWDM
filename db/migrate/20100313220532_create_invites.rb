class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
