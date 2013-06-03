class UnitOfStudy < ActiveRecord::Base
  has_many :results
  belongs_to :examiner
  validates_presence_of :ucode,:uname,:examiner_id
end
