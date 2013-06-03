class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table "configurations" do |t|
      t.string :cfg_key
      t.string :cfg_value
      t.text :cfg_value_txt   
      t.timestamps
    end
    
    
  end

  def self.down
    drop_table "configurations"
  end
end