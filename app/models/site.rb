class Site < ActiveRecord::Base
  has_many :environments, :dependent => :destroy
  validates :name, :presence => true
end
