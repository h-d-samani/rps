class Configuration < ActiveRecord::Base
  validates_presence_of :cfg_key
end