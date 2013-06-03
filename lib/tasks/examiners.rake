require 'ruby-debug'
namespace :import do
  desc "Import examiners from given file (default RAILS_ROOT/examiners.csv). It expects comma seperated fields."
  #note new task format is 'task :name, [:arguments] => [:dependences]'
  task :examiners, [:file] => [:environment] do |t, args|    
    args.with_defaults(:file => "examiners.csv")
    
    cnt_updates = 0
    cnt_inserts = 0
        
    begin
      CSV = FasterCSV if defined? FasterCSV
      raise "File #{args[:file]} not found" if !File.exist?("#{args[:file]}")      
      FasterCSV.foreach(args[:file], :headers => true, :return_headers => false) do |row|
        cms_id = row[0]
        searchstr = row[1]
        debugger
        code = cms_id.match(/[[:alpha:]]{4}[[:digit:]]{4}/)
        u = nil
        if (code.nil?)
          u = nil
        else
          u = Unit.find_by_code(code[0])
          #puts code[0] + ":::" + u.inspect
        end
                
        #update if it exists
        if u
          u.update_attributes({:cmscode => cms_id, :updated_at => Time.now})
          cnt_updates = cnt_updates + 1
        else
          newrec = Unit.new({:cmscode => cms_id, :searchstring => searchstr, :area => args[:area], :code => code})
          newrec.save!
          cnt_inserts = cnt_inserts + 1
        end
      end
      
      puts "Importing UoS is successful. #{cnt_inserts} added, #{cnt_updates} updated"
    rescue Exception => e
      puts "Importing UoS has failed."
      puts "#{e.message}"
    end
  end
  
  desc "Import units of study from given files (default RAILS_ROOT/uoslistforecho.csv). It expects comma seperated fields: UOSCODE, UOSNAME, Area, SemesterID. Run this first to populate table initially"
  task :uos, [:file] => [:environment] do |t, args|    
    args.with_defaults(:file => "uoslist.csv")
    
    cnt_updates = 0
    cnt_inserts = 0
        
    begin
      CSV = FasterCSV if defined? FasterCSV
      raise "File #{args[:file]} not found" if !File.exist?("#{args[:file]}")
      FasterCSV.foreach(args[:file], :headers => false, :return_headers => false) do |row|
        code = row[0]
        name = row[1]
        area = row[2]
        sems = row[3]
        year = row[5]      
        
        s = Semester.find_by_flexis_id_and_year(sems, year)
        if !s.present?
          s = Semester.find_by_name('Misc')
        end        
       #semestername = s.name.gsub(/-?\d{4}\s?-?\s?/,'')
        #semestername = s.name.sub('/-?\d{4}\s?-?\s?/','')        
        u = Unit.find_by_code_and_semester_id(code, s.id)
        #semestername = s.name.sub('-2012', '').gsub(/\s/, '_') #UAT
        semestername = s.name.gsub(/\s/, '_') #UAT        
        # /-?\d{4}\s?-?\s?/        
        #semestername = s.name.sub('2012 - ', '').gsub(/\s/, '_') #PROD
        calculated_cms = "#{s.year.to_s}_#{semestername}_#{code}"         
        #update if it exists
        if u
          u.update_attributes({:searchstring => name, :area => area, :updated_at => Time.now, :cmscode => calculated_cms})
          cnt_updates = cnt_updates + 1
        else
          newrec = Unit.new({:code => code, :searchstring => name, :area => area, :semester_id => s.id, :cmscode => calculated_cms})
          newrec.save!
          cnt_inserts = cnt_inserts + 1
        end
      end

      puts "Importing UoS is successful. #{cnt_inserts} added, #{cnt_updates} updated"
    rescue Exception => e
      puts "Importing UoS has failed."
      puts "#{e.message}"
    end
  end

  desc "Import users/cmsids from given file (default RAILS_ROOT/instructorslist.csv). It expects comma seperated fields: unikey, cmsid"
  task :units_of_study, [:file] => [:environment] do |t, args|
    args.with_defaults(:file => "uos.csv")     
    puts "#{UsersCmscode.all.count} records deleted."
    UsersCmscode.delete_all
    cnt_inserts = 0
    uos_inserts = 0

    begin
      raise "File #{args[:file]} not found" if !File.exist?("#{args[:file]}")
      FasterCSV.foreach(args[:file], :headers => false, :return_headers => false) do |row|
        unikey = row[0]
        cmscode = row[1]        
        UsersCmscode.create({:unikey => unikey, :cmscode => cmscode})

        code = cmscode.match(/[[:alpha:]]{4}[[:digit:]]{4}/)
        if (code.present?)
          code = code[0]
          u = Unit.find_or_create_by_code_and_cmscode(code, cmscode)
          uos_inserts = uos_inserts + 1
        end
        cnt_inserts = cnt_inserts + 1
      end

      puts "Importing successful, #{cnt_inserts} added, #{uos_inserts} UoSs added/updated"
    rescue Exception => e
      puts "Importing has failed."
      puts "#{e.message}"
    end    
  end

  

end


