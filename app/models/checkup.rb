class Checkup < ActiveRecord::Base
  belongs_to :environment

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

 private

  def request(url, timeout)
  Curl::Easy.perform(url) do |config|
    config.timeout = timeout
  end

end

end
