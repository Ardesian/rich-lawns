class ApplicationRecord < ActiveRecord::Base
  include Defaults
  
  self.abstract_class = true
end
