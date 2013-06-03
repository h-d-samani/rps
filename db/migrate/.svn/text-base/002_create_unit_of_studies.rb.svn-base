class CreateUnitOfStudies < ActiveRecord::Migration
  def self.up
    create_table "unit_of_studies" do |t|
      t.string :ucode
      t.string :uname
      t.integer :no_student
      t.integer :complete
      t.integer :semester
      t.integer :year
      t.integer :examiner_id
      t.timestamps
    end
    
    execute "alter table unit_of_studies
            add constraint UniqueUcode 
            UNIQUE (ucode)"
            
    execute "alter table unit_of_studies
            add constraint fk_unit_of_study_login 
            foreign key (examiner_id) references examiners(id)"   
  end

  def self.down
    drop_table "unit_of_studies"
  end
end