class Chart < ActiveRecord::Base
  belongs_to :environment

  def self.cache!(environment_id, days = 30)

    series = [:unhealthy_checkups_sum,
              :average_name_lookup_time,
              :average_start_transfer_time,
              :average_total_time,
              :average_downloaded_bytes,
              :retries_used_sum]
    starts_at = days.days.ago.at_midnight
    ends_at = 0.days.ago.at_midnight - 1

    bins = (1..days).collect do |day|
      bin_starts_at = day.days.ago.at_midnight
      bin_ends_at = (day - 1).days.ago.at_midnight - 1
      Checkup.select(
        'CAST(SUM(CASE WHEN `healthy`= 0 THEN 1 ELSE 0 END) AS UNSIGNED) AS `unhealthy_checkups_sum`,
        CAST(AVG(`name_lookup_time`) * 1000 AS UNSIGNED) AS `average_name_lookup_time`,
        CAST(AVG(`start_transfer_time`) * 1000 AS UNSIGNED) AS `average_start_transfer_time`,
        CAST(AVG(`total_time`) * 1000 AS UNSIGNED) AS `average_total_time`,
        CAST(AVG(`downloaded_bytes`) AS UNSIGNED) AS `average_downloaded_bytes`,
        CAST(SUM(`retries_used`) AS UNSIGNED) AS `retries_used_sum`'
      ).where(:created_at => bin_starts_at..bin_ends_at, :environment_id => environment_id).first
    end.reverse

    Chart.where(:environment_id => environment_id).destroy_all

    series.each do |series|
      data = bins.map { |bin| bin[series] }
      Chart.create(:environment_id => environment_id,
                :starts_at => starts_at,
                :ends_at => ends_at,
                :series => series,
                :data => data.to_json)
    end

  end

end
