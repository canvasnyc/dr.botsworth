class Environment < ActiveRecord::Base
  belongs_to :site
  validates :name, :url, :site_id, :presence => true
  validates :url, :url => true
  validates :timeout, :retries, :between_retries_wait,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 },
    :allow_nil => true

  def timeout
    self[:timeout] || Settings.environment!.default!.timeout
  end

  def retries
    self[:retries] || Settings.environment!.default!.retries
  end

  def between_retries_wait
    self[:between_retries_wait] || Settings.environment!.default!.between_retries_wait
  end

  def ip_relay_commands
    if self[:ip_relay_commands].empty?
      Settings.environment!.default!.ip_relay_commands
    else
      self[:ip_relay_commands]
    end
  end
end
