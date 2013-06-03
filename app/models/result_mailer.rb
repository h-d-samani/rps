class ResultMailer < ActionMailer::Base
  
  def report_email(from_user, to_user,subject,fileattachments, content_type = 'text/plain')
    @recipients  = ["#{to_user}"]
    @from        = "#{from_user}"
    @subject     = "#{subject}"
    @sent_on     = Time.now
    @content_type = content_type 
    
    for f in fileattachments
      attachment :content_type => "text/plain",
           :filename     => f, 
           :body         => File.read(RAILS_ROOT + "/tmp/attachments/"+f)
    end
  end

  def examiner_email(from_user, to_user,subject, unit_of_study, result, content_type = 'text/plain')
    @recipients  = ["#{to_user}"]
    @from        = "#{from_user}"
    @subject     = "#{subject}"
    @sent_on     = Time.now
    @content_type = content_type
    
    @c1= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_SEMESTER'"])
    @c2= Configuration.find(:first, :conditions => ["cfg_key = 'CFG_KEY_YEAR'"])    

    body[:c1]= @c1
    body[:c2]= @c2
    body[:unit_of_study]  = unit_of_study
    body[:result]= result
    
  end
  
  def examiner_notification(from_user, to_user,subject, login, password,uos_list,email_template,signature, content_type = 'text/plain')
    @recipients  = ["#{to_user}"]
    @from        = "#{from_user}"
    @subject     = "#{subject}"
    @sent_on     = Time.now
    @content_type = content_type
    
    body[:login]  = login
    body[:password] = password
    body[:email_template] =email_template
    body[:signature]= signature
    body[:uos_list]= uos_list
    
  end
  
   def examiner_password(from_user, to_user,subject, password, content_type = 'text/plain')
    @recipients  = ["#{to_user}"]
    @from        = "#{from_user}"
    @subject     = "#{subject}"
    @sent_on     = Time.now
    @content_type = content_type
    
    body[:password] = password
    
  end
  
  
end