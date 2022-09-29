# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class Index
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      working_times = WorkingTime.includes(:week)
                                 .where(company_id: @params[:company_id], week_id: weeks.pluck(:id))
                                 .all
                                 .order('weeks.from_date DESC')
                                 .group_by{ _1&.week_id }
      # byebug
      {
        succeed: true,
        working_times: working_times
      }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength

    private

    def picked_date
      return @params[:day_in_month] if @params[:day_in_month].present?

      DateTime.now
    end

    def list_monday_in_month
      WeekService.new(picked_date).list_monday_in_range
    end

    def weeks
      Week.where(from_date: list_monday_in_month)
    end
  end
  # rubocop:enable Style/Documentation
end
