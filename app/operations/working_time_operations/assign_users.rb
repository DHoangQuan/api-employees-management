# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class AssignUsers
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      return { succeed: 'fail', message: 'User Not Found' } if @params[:user_id].present? && user.blank?
      return { succeed: 'fail', message: 'Working Time Not Found' } unless working_time.present?

      status = working_time.update(user_id: user&.id)

      return { succeed: true, company_id: working_time.company_id } if status

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

    private

    def working_time
      WorkingTime.find_by_id(@params[:id])
    end

    def user
      return nil unless @params[:user_id].present?

      User.find_by_id(@params[:user_id])
    end
  end
  # rubocop:enable Style/Documentation
end
