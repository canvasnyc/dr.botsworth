class Checkup < ActiveRecord::Base
  belongs_to :environment

  Time.zone = Settings.time_zone

  def perform
    throw 'Missing `environment_id` association' unless environment_id
    retries = environment.retries
    begin
      c = request(environment.url, environment.timeout)

      [:name_lookup_time, :start_transfer_time,
        :total_time, :downloaded_bytes].each do |sym|
        send("#{sym}=", c.send(sym))
      end

      if c.response_code == 200
        self.healthy = true
      else
        self.error = "response code was: #{c.response_code}"
      end
    # http://curb.rubyforge.org/classes/Curl/Err.html
    rescue Exception => e
      if retries > 0
        retries -= 1
        print "retrying in #{environment.between_retries_wait}s..."
        STDOUT.flush
        sleep(environment.between_retries_wait)
        retry
      else
        self.error = "an exception occurred: #{e}"
      end
    end
    self.retries_used = environment.retries - retries

    self.save
  end

  def alert
    unless self.healthy?
      ip_relay.alert({
        :environment => {
          :id => self.environment.id,
          :name => self.environment.name,
          :url => self.environment.url
        },
        :site => self.environment.site.name,
        :commands => self.environment.ip_relay_commands,
        :url => "#{Settings.checkups!.url}#{self.id}"
      })
    end
  end

  def performed_on
    self.created_at.strftime('%b %e, %Y %l:%M %P')
  end

 private

  def request(url, timeout)
    Curl::Easy.perform(url) do |config|
      config.timeout = timeout
    end
  end

  def ip_relay
    IPRelay::Downtime.new(Settings.ip_relay)
  end

end
