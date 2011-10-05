class Environment < ActiveRecord::Base
  belongs_to :site
  has_many :checkups, :dependent => :destroy
  validates :name, :url, :site_id, :presence => true
  validates :url, :url => true
  validates :timeout, :retries, :between_retries_wait,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 },
    :allow_nil => true

  def timeout
    self[:timeout] || default.timeout
  end

  def retries
    self[:retries] || default.retries
  end

  def between_retries_wait
    self[:between_retries_wait] || default.between_retries_wait
  end

  def ip_relay_commands
    if self[:ip_relay_commands].empty?
      default.ip_relay_commands
    else
      self[:ip_relay_commands]
    end
  end

  # creates a fake site, environment, and checkup to test the iP Relay integration
  def test_alert
    checkup = Checkup.new
    checkup.error = "test of downtime alert for #{self.site.name} #{self.name}"

    environment = Environment.new
    environment.ip_relay_commands = self.ip_relay_commands
    environment.url = 'http://www.example.com/'
    environment.id = rand(999)
    environment.name = 'test'
    checkup.environment = environment

    site = Site.new
    site.name = 'Dr. Botsworth'
    checkup.environment.site = site

    checkup.alert
  end

  def default
    Settings.environment!.default!
  end

end
