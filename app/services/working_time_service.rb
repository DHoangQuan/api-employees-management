# frozen_string_literal: true

# rubocop:disable Style/Documentation
class WorkingTimeService
  def initialize(params)
    @params = params
  end

  # rubocop:disable Metrics/AbcSize
  def total_working_hours
    [
      working_hours_per_day(@params['mon'] || @params['monday']),
      working_hours_per_day(@params['tue'] || @params['tuesday']),
      working_hours_per_day(@params['wed'] || @params['wednesday']),
      working_hours_per_day(@params['thu'] || @params['thursday']),
      working_hours_per_day(@params['fri'] || @params['friday']),
      working_hours_per_day(@params['sat'] || @params['saturday'], not_minus_break_time: true)
    ].inject(0, :+)
  end
  # rubocop:enable Metrics/AbcSize

  private

  def working_hours_per_day(time_range, not_minus_break_time: false)
    return 0 if time_range.nil? || time_range.empty?

    st, en = time_range.split('-')
    working_hours = ("#{en}PM".to_time - "#{st}AM".to_time) / 3600

    return working_hours if not_minus_break_time

    working_hours - 0.5
  end
end
# rubocop:enable Style/Documentation
