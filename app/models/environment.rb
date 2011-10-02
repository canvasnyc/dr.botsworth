class Environment < ActiveRecord::Base
  belongs_to :site
  validates :name, :url, :site_id, :presence => true
  validates :url, :url => true
end
