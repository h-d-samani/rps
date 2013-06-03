class LoginController < ApplicationController
  layout "baseapp"
  
  def login
    session[:examiner_id] = nil
    if request.post?
      examiner = Examiner.authenticate(params[:name],params[:password])
      if examiner
        examiner = Examiner.update(examiner.id, :last_login => Time.new )
        session[:examiner_id]=examiner.id
        uri = session[:original_uri]
        session[:original_uri]=nil
        redirect_to(uri || {:controller =>"uos",:action => "index"})
      else
        flash[:notice] = "Invalid login name or password "
      end
    end
  end
  
  def logout
    session[:examiner_id] = nil
    session[:original_uri]=nil
    redirect_to(:controller => "login", :action=>"login")
  end
  
  def password
    if (params[:email])
      @examiner = Examiner.find(:first, :conditions => ["email = ?", params[:email]])
      
      if @examiner
        @subject = "Your results processing password" 
        ResultMailer.deliver_examiner_password('no_reply@usyd.edu.au',@examiner.email,@subject,@examiner.password)
        
        flash[:notice] = "Password has been send to your email account."
      else
        flash[:notice] = "Email address can not be matched.";
      end
    end
  end  
  
  def findclassname
    @unit_of_studies =[]
    if (params[:code])
      @unit_of_studies = UnitOfStudy.find(:all, :conditions => ["ucode LIKE ?", params[:code]+"%"])
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @unit_of_studies }
      end
    end
  end
  
  def rphelp  
  end
end