class CreateResults < ActiveRecord::Migration
  def self.up
    create_table "results" do |t|
      t.integer :unit_of_study_id
      t.string :sid
      t.string :sname
      t.string :fname
      t.string :degree
      t.integer :calyear  
      t.integer :semester
      t.integer :mark
      t.string :grade
      t.timestamps
    end
    
    execute "alter table results
            add constraint UniqueUcodeSid 
            UNIQUE (unit_of_study_id,sid)"
            
    execute "alter table results
            add constraint fk_result_ucode 
            foreign key (unit_of_study_id) references unit_of_studies(id)"   
  end

  def self.down
    drop_table "results"
  end
end