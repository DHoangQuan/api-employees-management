# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class Show
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      working_time = WorkingTime.find_by_id(@params[:id])

      return { success: 'fail', message: e.inspect } unless working_time.present?

      {
        success: true,
        working_time: working_time
      }
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
