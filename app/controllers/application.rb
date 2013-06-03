# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # TODO: If using ExceptionNotifier, uncomment the line below to cause 
  # exceptions thrown by any subclass of this controller to be emailed as per
  # the ExceptionNotifier configuration in the environment config files.
  # include ExceptionNotifiable
  
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => '0a46eac1a509bf229afd68c0b7d28824'
  MAX_SESSION_TIME = 30 * 60
  
  private
  
  def authorize
    
    if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      session[:examiner_id] = nil
      session[:original_uri]=nil
   end

    unless Examiner.find_by_id(session[:examiner_id])        
      session[:original_uri] = request.request_uri
      redirect_to(:controller => "login", :action=>"login")
    end
    
    session[:expiry_time] = MAX_SESSION_TIME.seconds.from_now
  end
  
  def admin_authorize

    if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      session[:examiner_id] = nil
      session[:original_uri]=nil
   end
  
    unless Examiner.find_by_id(session[:examiner_id])  
      session[:original_uri] = request.request_uri
      redirect_to(:controller => "login", :action=>"login") 
    else
      examiner =Examiner.find_by_id(session[:examiner_id]) 
      if examiner.admin != true
        session[:original_uri] = request.request_uri
        redirect_to(:controller => "login", :action=>"login")          
      end  
    end  
    
    session[:expiry_time] = MAX_SESSION_TIME.seconds.from_now
  end
  
end