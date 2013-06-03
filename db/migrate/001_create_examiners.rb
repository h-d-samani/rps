class CreateExaminers < ActiveRecord::Migration
  def self.up
    create_table "examiners" do |t|
      t.string :login
      t.string :password
      t.string :name
      t.string :email
      t.boolean :admin
      t.timestamp :last_login      
      t.timestamps
    end
    
    execute "alter table examiners
            add constraint UniqueLogin 
            unique (login)"
    
  end

  def self.down
    drop_table "examiners"
  end
end