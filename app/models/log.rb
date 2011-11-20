class Log

  class << self

    # Uses tail to read a certain number of lines from the checkup log (the
    # output from the environments:checkup Rake task).
    def read(lines)
      if self.numeric?(lines) and lines.to_i > 0
        `tail -n #{lines} #{File.join(Rails.root, '/log/checkup.log')}`
      else
        "Invalid parameter: #{lines}"
      end
    end

  protected

    def numeric?(value)
      value =~ /^\d+$/
    end

  end # self
end # Log
