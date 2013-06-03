class Examiner < ActiveRecord::Base
  has_many :unit_of_studies
  validates_presence_of :login, :password

def self.authenticate(login,password)
    examiner=self.find_by_login(login)
    if examiner
      if examiner.password != password
        examiner = nil      
      end
    else
      examiner = nil
    end  
    examiner
end


end
