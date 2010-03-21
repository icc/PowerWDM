class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.integer :domain_id, :null => true
      t.string :name, :null => true
      t.string :type, :null => true
      t.string :content, :null => true
      t.integer :ttl, :null => true
      t.integer :prio, :null => true
      t.integer :change_date, :null => true
      t.timestamps
    end
    add_index(:records, :name, :unique => false, :name => 'rec_name_index')
    add_index(:records, [:name, :type], :unique => false, :name => 'nametype_index')
    add_index(:records, :domain_id, :unique => false, :name => 'domain_id')
  end

  def self.down
    drop_table :records
  end
end
