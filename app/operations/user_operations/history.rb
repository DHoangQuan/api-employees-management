# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class History
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      return { succeed: 'fail', message: 'User Not Found' } unless user.present?

      working_times = WorkingTime.where(user_id: @user.id, week_id: weeks.pluck(:id))&.group_by(&:company_id)

      {
        succeed: true,
        weeks: weeks.group_by(&:id),
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

    def user
      @user = User.find_by_id(@params[:id])
    end

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
