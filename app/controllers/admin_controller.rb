class AdminController < ApplicationController
  layout "baseapp"
  before_filter :admin_authorize
  
  def index

  end
  
  def results_export_form   
    @e= Examiner.find(:all,:order => "name")
    @u= UnitOfStudy.find(:all, :order => "uname")
  end
  
  def results_export
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])    
     
    if params
      @params=params
      search_term = "1=1"
      if @params["complete"]
        if @params["complete"]== "1"
          search_term =search_term + " and complete = 1"
        end
        if @params["complete"]== "2"
          search_term =search_term + " and complete = 2"
        end      
        if @params["complete"]== "3"
          search_term =search_term + " and (complete is null ) "
        end
        p search_term
        if @params["ucode"]["id"]!= ""
          search_term =search_term + " and id='"+ @params["ucode"]["id"]+"'"
        end  
        if @params["login"]["id"]!= ""
          search_term =search_term + " and examiner_id='"+ @params["login"]["id"]+"'"
        end  
        @o= UnitOfStudy.find(:all, :conditions => [search_term])
        
        if (@params["export"]=="yes")
          @filenames = []
          examiner =Examiner.find_by_id(session[:examiner_id]) 
          i=0
          for @oo in @o
            if File.exist?(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt")
              File.delete(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt")
            end
            logfile = File.new(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt", "w")
            @filenames[i]=@oo.ucode+".txt"
            for result in @oo.results
              if result.mark == nil
                mark=""
              else
                mark =result.mark.to_s
              end
              if result.grade == nil
                grade=""
              else
                grade =result.grade
              end
              logfile.puts result.sid+"\t"+result.sname+"\t"+result.fname+"\t"+ result.degree+"\t"+ result.calyear.to_s+"\t"+ @oo.ucode+"\t"+ result.semester.to_s+"\t"+ mark+"\t"+ grade+"\n"
            end
            logfile.close
            i=i+1
          end
          @subject = "Results Semester " + @c1.cfg_value+", "+ @c2.cfg_value 
          ResultMailer.deliver_report_email('no_reply@usyd.edu.au',examiner.email,@subject,@filenames)
        end
      end 
    end  
  end
  
  def uos_unlock
    @o= UnitOfStudy.find(:all, :conditions => ["complete = 1 or complete = 2 "])
    
    if params
      @params=params
      i=0
      ii=0
      while i < @params['i'].to_i
        i=i+1 
        if (@params['choice_'+i.to_s] != nil) then
          if (@params['choice_'+i.to_s]['0'] !=nil and @params['choice_'+i.to_s]['0'].length>0 ) then
            uid = @params['choice_'+i.to_s]['0']
            @u = UnitOfStudy.find_by_id(uid)
            @u.complete = nil
            @u.save
            ii=ii+1
          end
        end
      end  
    end
    if(ii > 0)
      flash[:notice] = "UOS has been unlocked."
      redirect_to(:controller => "admin", :action=>"index")
    end  
  end
  
  def examiner_list
    @e= Examiner.find(:all,:order => "name")
  end
  
  def examiner_edit
    @e = Examiner.find(params[:examiner_id])
    if (params[:email])
      @e = Examiner.find(params[:examiner_id])
      @e.email =params[:email]
      if params[:admin] == 'yes'
        @e.admin = true
      else
        @e.admin = nil  
      end
      @e.save      
      flash[:notice] = "Examiner has been changed."
    end  
  end
  
  def results_list
    # @o= UnitOfStudy.find(:all, :conditions => ["complete = 1"])
    @o= UnitOfStudy.find(:all, :conditions => ["complete = 1 or complete = 2"])
  end
  
  def results_list_export
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])    
    
    if params
      @params=params
      i=0
      ii=0
      search_term =""
      while i < @params['i'].to_i
        i=i+1 
        if (@params['choice_'+i.to_s] != nil) then
          if (@params['choice_'+i.to_s]['0'] !=nil and @params['choice_'+i.to_s]['0'].length>0 ) then
            uid = @params['choice_'+i.to_s]['0']
            ii=ii+1
            if ii==1
              search_term = "id in("+uid
            else
              search_term = search_term +", "+uid
            end
          end
        end  
      end
      if ii>0
        search_term = search_term +")"
        @o= UnitOfStudy.find(:all, :conditions => [search_term])
        
        if (@params["export"]=="Y")
          @filenames = []
          examiner =Examiner.find_by_id(session[:examiner_id]) 
          i=0
          for @oo in @o
            if File.exist?(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt")
              File.delete(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt")
            end
            logfile = File.new(RAILS_ROOT + "/tmp/attachments/"+@oo.ucode+".txt", "w")
            @filenames[i]=@oo.ucode+".txt"
            for result in @oo.results
              if result.mark == nil
                mark=""
              else
                mark =result.mark.to_s
              end
              if result.grade == nil
                grade=""
              else
                grade =result.grade
              end
               logfile.puts result.sid+"\t"+result.sname+"\t"+result.fname+"\t"+ result.degree+"\t"+ result.calyear.to_s+"\t"+ @oo.ucode+"\t"+ result.semester.to_s+"\t"+ mark+"\t"+ grade+"\n"
           end
            logfile.close
            i=i+1
          end
          @subject = "Results Semester " + @c1.cfg_value+", "+ @c2.cfg_value 
          ResultMailer.deliver_report_email('no_reply@usyd.edu.au',examiner.email,@subject,@filenames)
        end
      end
    end
  end
  
  def configuration
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])
    @c3= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_EMAIL'"])
    @c4= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SIGNATURE'"])
    
    @semester=''
    if @c1
      @semester=@c1.cfg_value
    end
    
    @year=''
    if @c2
      @year=@c2.cfg_value
    end
    
    @email=''
    if @c3
      @email=@c3.cfg_value_txt
    end
    
    @signature=''
    if @c4
      @signature=@c4.cfg_value_txt
    end
    
    if params["semester"]
      @params=params
      
      @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
      if @c1
        @c1.cfg_value=@params['semester']
        @c1.save
      else  
        @c1 = Configuration.new
        @c1.cfg_key='CFG_KEY_SEMESTER'
        @c1.cfg_value=@params['semester']
        @c1.save
      end
      @semester=@c1.cfg_value
      
      @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])
      if @c2
        @c2.cfg_value=@params['year']
        @c2.save
      else  
        @c2 = Configuration.new
        @c2.cfg_key='CFG_KEY_YEAR'
        @c2.cfg_value=@params['year']
        @c2.save
      end
      @year=@c2.cfg_value    
      
      @c3= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_EMAIL'"])
      if @c3
        @c3.cfg_value_txt=@params['email']
        @c3.save
      else  
        @c3 = Configuration.new
        @c3.cfg_key='CFG_KEY_EMAIL'
        @c3.cfg_value_txt=@params['email']
        @c3.save
      end
      @email=@c3.cfg_value_txt  
      
      @c4= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SIGNATURE'"])
      if @c4
        @c4.cfg_value_txt=@params['signature']
        @c4.save
      else  
        @c4 = Configuration.new
        @c4.cfg_key='CFG_KEY_SIGNATURE'
        @c4.cfg_value_txt=@params['signature']
        @c4.save
      end
      @signature=@c4.cfg_value_txt  
      
      flash[:notice] = "Configuration parameters have been updated."
      redirect_to(:controller => "admin", :action=>"index")
    
    end    
  end
  
  def examiner_notification
    @e= Examiner.find(:all,:order => "name")
    if params["login"]
      @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
      @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])
      @c3= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_EMAIL'"])
      @c4= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SIGNATURE'"])
      
      @params=params
      p @params
      i=0
      while i < @params["login"]["id"].length
        @id =@params["login"]["id"][i]
        p i.to_s+" "+@id.to_s      
        @ee= Examiner.find_by_id(@id)
        uos_list=''
        for @u in @ee.unit_of_studies 
          uos_list= uos_list+" "+ @u.ucode    
        end 
        @subject = "Semester "+@c1.cfg_value+" "+@c2.cfg_value+" Results Processing"
        ResultMailer.deliver_examiner_notification('no_reply@usyd.edu.au',@ee.email,@subject,@ee.login,@ee.password, uos_list,@c3.cfg_value_txt, @c4.cfg_value_txt)
        i=i+1
      end  
      flash[:notice] = "Examiner has been notified."      
      redirect_to(:controller => "admin", :action=>"index")
    end  
  end
  
  def uos_list
    @u= UnitOfStudy.find(:all,:order => "ucode")
  end

  def uos_edit
    @u = UnitOfStudy.find(params[:uos_id])
    @e= Examiner.find(:all,:order => "name")  
    if params
      @params=params
      if @params["examiner"]   
        @u.examiner_id = @params["examiner"]["id"]
        @u.save      
        flash[:notice] = "Examiner has been changed."
      end
    end
  end

end