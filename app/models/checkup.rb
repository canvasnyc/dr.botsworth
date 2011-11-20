class Checkup < ActiveRecord::Base
  belongs_to :environment

  # Performs a health checkup on the associated environment
  def perform
    throw 'Missing `environment_id` association' unless environment_id
    retries = environment.retries
    begin
      # Perform an HTTP GET request using cURL.
      curl = request(environment.url, environment.timeout)

      # Record a few measurements from the request instance.
      [:name_lookup_time, :start_transfer_time,
        :total_time, :downloaded_bytes].each do |sym|
        send("#{sym}=", curl.send(sym))
      end

      # At this point, a Curl::Err exception has not been thrown. However,
      # we'll only consider the site to be healthy if a 200 OK response code
      # has been received.
      if curl.response_code == 200
        self.healthy = true
      else
        self.error = "response code was: #{curl.response_code}"
      end
    # Rescues any kind of exception, including Curl::Err:
    # http://curb.rubyforge.org/classes/Curl/Err.html
    rescue Exception => e
      if retries > 0
        retries -= 1
        print "retrying in #{environment.between_retries_wait}s..."
        # Cause the console output to refresh in case someone is watching this
        # live.
        STDOUT.flush
        sleep(environment.between_retries_wait)
        retry
      else
        self.error = "an exception occurred: #{e}"
      end
    end
    # Calculate and record the number of retries used.
    self.retries_used = environment.retries - retries

    self.save
  end

  # Unless the checkup result was healthy, send a downtime alert via iP Relay.
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
        :url => "#{Settings.checkups[:url]}#{self.id}"
      })
    end
  end

  def performed_on
    self.created_at.strftime('%b %e, %Y %l:%M %P')
  end

 private

  # Performs an HTTP GET request using cURL.
  #
  # Parameters
  # [url]
  #   URL on which to perform the request.
  # [timeout]
  #   Maximum time in seconds to allow the transfer to take. Throws an
  #   Curl::Err::TimeoutError if reached.
  def request(url, timeout)
    Curl::Easy.perform(url) do |config|
      config.timeout = timeout
    end
  end

  # Serves up a configured iP Relay downtime alert instance.
  def ip_relay
    IPRelay::Downtime.new(Settings.ip_relay)
  end

end
