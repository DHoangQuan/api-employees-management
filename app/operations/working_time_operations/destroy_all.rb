# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class DestroyAll
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      status = WorkingTime.where(uuid: @params[:uuid]).destroy_all

      return { succeed: true } if status

      {
        succeed: 'fail',
        message: 'Update failed'
      }
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
