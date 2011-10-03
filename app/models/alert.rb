class Alert

  def self.send(checkup)
    if checkup.healthy?
      false
    else
      ip_relay.alert({
        :url => checkup.environment.url,
        :id => checkup.environment.id,
        :site => checkup.environment.site.name,
        :commands => checkup.environment.ip_relay_commands,
        :environment => checkup.environment.name,
        :message => checkup.error
       })
    end
  end

  def self.test(commands)
    ip_relay.alert({
      :url => 'http://www.example.com/',
      :id => rand(999),
      :site => 'Dr. Botsworth',
      :commands => commands,
      :environment => 'test',
      :message => 'test of iP Relay integration'
     })
  end

 private

  def self.ip_relay
    IPRelay::Downtime.new(Settings.ip_relay)
  end
end