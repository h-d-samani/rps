require 'ruby-debug'
namespace :import do
  desc "Import examiners and units of study from given .csv file (default RAILS_ROOT/examiners.csv). It expects comma seperated fields."
  #note new task format is 'task :name, [:arguments] => [:dependences]'
  task :examiners, [:file] => [:environment] do |t, args|    
    args.with_defaults(:file => "ExaminersList.csv")
    Result.delete_all 
    UnitOfStudy.delete_all
    Examiner.delete_all
    begin
      CSV = FasterCSV if defined? FasterCSV
      raise "File #{args[:file]} not found" if !File.exist?("#{args[:file]}")      
      FasterCSV.foreach(args[:file], :headers => true, :return_headers => false) do |row|
        ucode = row[0] + row[1]
        uname = row[2]
        name = row[3]
        email = row[4]
        login = row[4][0, row[4].index("@")]
        # Generate a random passowrd
        chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        password=""
        1.upto(8) { |i| password << chars[rand(chars.size-1)] }        
        examiner = Examiner.find_by_login(login)
        if examiner
          examiner.update_attributes({:email => email, :name => name, :password => password})
        else
          Examiner.create({:login => login, :email => email, :name => name, :password => password})
        end             
        examiner = Examiner.find_by_login(login)
        uos = UnitOfStudy.find_by_examiner_id_and_ucode(examiner.id, ucode)
        if uos
          uos.update_attributes({:uname => uname, :examiner_id => examiner.id, :no_student => 0})
        else
          UnitOfStudy.create({:ucode => ucode, :uname => uname, :examiner_id => examiner.id, :no_student => 0})
        end
      end
      
      puts "Importing Examiners & Units of Study is successful."
    rescue Exception => e
      puts "Importing has failed."
      puts "#{e.message}"
    end
  end
  
  desc "Import results from given files"
  task :results, [:file] => [:environment] do |t, args|

    begin
      data_folder = "data"
      cnt_files = 0
      str=""        
      Dir.glob("#{data_folder}/**/*").each do |f|
        File.open(f, "r").each_line do |line|
          str = line.gsub!(/\r\n/,"").split(/\t/)
          sid = str[0]
          fname = str[2]
          sname = str[1]
          calyear = str[4].to_i
          ucode = str[5]
          semester = str[6].to_i
          degree = str[3]
          
          uos = UnitOfStudy.find_by_ucode(ucode)
          if !uos
            puts "Unit of Study #{ucode} not found"
          else
            result = Result.find_by_sid_and_unit_of_study_id(sid, uos.id)
            if result
              result.update_attributes({:fname => fname, :sname => sname, :degree => degree, :calyear => calyear, :semester => semester})              
            else
              Result.create({:sid => sid, :fname => fname, :sname => sname, :degree => degree, :calyear => calyear, :unit_of_study_id => uos.id, :semester => semester})
            end
          end
        end
        cnt_files = cnt_files + 1
      end
      puts "Importing results is successful. #{cnt_files} files were read"
    rescue Exception => e
      puts "Importing UoS has failed."
      puts "#{e.message}"
    end
  end

end


