class Site < ActiveRecord::Base
  has_many :environments
  validates :name, :presence => true
end
