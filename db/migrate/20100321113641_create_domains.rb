class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :name, :null => false
      t.string :master, :null => true
      t.integer :last_check, :null => true
      t.string :type, :null => false
      t.integer :notified_serial, :null => true
      t.string :account, :null => true
      t.integer :user_id, :null => true
      t.timestamps
    end
    add_index(:domains, :name, :unique => true, :name => 'name_index')
    # Create custom reverse function
    puts "create function reverse(text) returns text as $$"
    puts "select case when length($1)>0"
    puts "then substring($1, length($1), 1) || reverse(substring($1, 1, length($1)-1))"
    puts "else '' end $$ language sql immutable strict;"
  end

  def self.down
    drop_table :domains
    puts "drop function reverse"
  end
end
