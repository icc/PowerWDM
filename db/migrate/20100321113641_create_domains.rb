class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name, :null => false
      t.string :master, :null => true
      t.integer :last_check, :null => true
      t.string :type, :null => false
      t.integer :notified_serial, :null => true
      t.string :account, :null => true
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index(:domains, :name, :unique => true, :name => 'name_index')
  end

  def self.down
    drop_table :domains
  end
end
