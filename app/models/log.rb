class Log
  def self.read(lines)
    `tail -n #{lines} #{File.join(Rails.root, '/log/checkup.log')}`
  end
end