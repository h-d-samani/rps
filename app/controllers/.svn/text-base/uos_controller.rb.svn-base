class UosController < ApplicationController
  layout "baseapp"
  before_filter :authorize
  
  def index
    
    @unit_of_studies = UnitOfStudy.find(:all, :conditions => ["examiner_id = ?", session[:examiner_id]])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @unit_of_studies }
    end
  end
  
  def student_list
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])
    
    @unit_of_study = UnitOfStudy.find_by_id( params[:id] )
    if (@unit_of_study.complete == 1 or @unit_of_study.examiner_id != session[:examiner_id])
      flash[:notice] = "You can't update this UOS"
      redirect_to(:controller => "uos", :action=>"index")
    end
    @results = Result.find(:all, :conditions => ["unit_of_study_id = ?", params[:id]], :order=>"sname" )
    
  end
  
  def update
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])    
    
    @params=params
    i=0
    
    complete =1
    no_of_students=@params["no_sid"].to_i
    no_of_students.times do
      result = Result.find(@params["s#{i}"])
      result.mark = @params["m#{i}"]
      if @params["g#{i}"] !=""
        result.grade = @params["g#{i}"].upcase
      else
        result.grade =""
      end  
      if result.grade =="INC"
        complete =2
      end
      result.save 
      i +=1
    end
    
    @unit_of_study = UnitOfStudy.find_by_id( params[:subj] )
    @results = Result.find(:all, :conditions => ["unit_of_study_id = ?", params[:subj]], :order=>"sname" )

    if @params["complete"]   
      examiner =Examiner.find_by_id(session[:examiner_id])
      @unit_of_study.complete = complete
      @unit_of_study.save
      
      @subject = @unit_of_study.ucode + " Semester " + @c1.cfg_value+", "+ @c2.cfg_value 
      ResultMailer.deliver_examiner_email('no_reply@usyd.edu.au',examiner.email,@subject,@unit_of_study,@results)
      
      flash[:notice] = "Completed Results for "+@unit_of_study.ucode+" "+@unit_of_study.uname
    else
      flash[:notice] = "Results for "+@unit_of_study.ucode+" "+@unit_of_study.uname+" "+"saved to disk."
    end
    
  end
  
end