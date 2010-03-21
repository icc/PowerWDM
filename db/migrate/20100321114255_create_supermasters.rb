class CreateSupermasters < ActiveRecord::Migration
  def self.up
    create_table :supermasters do |t|
      t.string :ip, :null => false
      t.string :nameserver, :null => false
      t.string :account, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :supermasters
  end
end
