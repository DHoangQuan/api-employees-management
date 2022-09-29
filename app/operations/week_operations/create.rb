# frozen_string_literal: true

module WeekOperations
  # rubocop:disable Style/Documentation
  class Create
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      start_date_of_week = @params[:date].beginning_of_week
      end_date_of_week = @params[:date].end_of_week

      week = Week.new(
        from_date: Utils::ConvertTime.only_date(start_date_of_week),
        to_date: Utils::ConvertTime.only_date(end_date_of_week)
      )

      return { succeed: 'fail', message: week.errors.objects.first.full_message } unless week.valid?

      week.save

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
