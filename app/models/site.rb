class Site < ActiveRecord::Base
  has_many :environments
  validates :name, :presence => true
  validates :timeout, :retries, :between_retries_wait,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 },
    :allow_nil => true

  def timeout
    read_attribute(:timeout) || Settings.default!.timeout
  end

  def retries
    read_attribute(:retries) || Settings.default!.retries
  end

  def between_retries_wait
    read_attribute(:between_retries_wait) || Settings.default!.between_retries_wait
  end

  def ip_relay_commands
    if read_attribute(:ip_relay_commands).empty?
      Settings.default!.ip_relay_commands
    else
      read_attribute(:ip_relay_commands)
    end
  end
end
