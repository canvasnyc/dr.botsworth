class Environment < ActiveRecord::Base
  belongs_to :site
  has_many :checkups, :dependent => :destroy
  validates :name, :url, :site_id, :presence => true
  validates :url, :url => true
  validates :timeout, :retries, :between_retries_wait,
    :numericality => {:only_integer => true, :greater_than_or_equal_to => 0},
    :allow_nil => true

  # Maximum time in seconds to allow a transfer to take. If nil, use the
  # default value instead.
  def timeout
    self[:timeout] || default.timeout
  end

  # Number of times to retry the transfer. If nil, use the default value
  # instead.
  def retries
    self[:retries] || default.retries
  end

  # Time in seconds to wait between retrying the transfer. If nil, use the
  # default value instead.
  def between_retries_wait
    self[:between_retries_wait] || default.between_retries_wait
  end

  # The iP Relay commands to execute. If nil, use the default value instead.
  # For more information on iP Relay commands, please see:
  # https://github.com/toddmazierski/ip-relay
  def ip_relay_commands
    if self[:ip_relay_commands].empty?
      default.ip_relay_commands
    else
      self[:ip_relay_commands]
    end
  end

  # Creates a fake site, environment, and checkup to test the iP Relay
  # integration.
  def test_alert
    checkup = Checkup.new

    environment = Environment.new
    # Assign the fake environment the real iP Relay commands for this
    # environment.
    environment.ip_relay_commands = self.ip_relay_commands
    environment.url = 'http://www.example.com/'
    # Create a random environment ID to circumvent iP Relay's "lookback"
    # feature, which under normal circumstances, prevents the same alert from
    # popping up over and over within a period of time (by default, 1 hour).
    environment.id = rand(2**63)
    environment.name = "(test alert for #{self.site.name} #{self.name})"
    checkup.environment = environment

    site = Site.new
    site.name = 'Dr. Botsworth'
    checkup.environment.site = site

    checkup.alert
  end

  def default
    Settings.environment[:default]
  end

end
