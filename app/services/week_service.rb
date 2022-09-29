# frozen_string_literal: true

# rubocop:disable Style/Documentation
class WeekService
  def initialize(day)
    @day = day.to_date
  end

  def beginning_week_of_month
    first_day = @day.beginning_of_month

    first_day.beginning_of_week
  end

  def end_week_of_month
    end_date = @day.end_of_month

    end_date.beginning_of_week
  end

  def list_monday_in_range
    list_monday = []

    f_day = beginning_week_of_month
    l_day = end_week_of_month
    while f_day < l_day
      f_day += 7.days if list_monday.present?
      list_monday << f_day
    end

    list_monday
  end
end
# rubocop:enable Style/Documentation
