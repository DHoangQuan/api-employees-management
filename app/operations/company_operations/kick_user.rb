# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class KickUser
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      return { success: 'fail', message: 'User Not Found' } unless user.present?
      return { success: 'fail', message: 'Company Not Found' } unless company.present?
      return { success: 'fail', message: 'User has not join this company' } unless company_user.present?
      return { success: 'fail', message: 'Working Time present?' } if working_time?.present?

      @company_user.destroy

      {
        success: true
      }
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength

    private

    def company
      @company = Company.find_by_id(@params[:id])
    end

    def user
      @user = User.find_by_id(@params[:user_id])
    end

    def company_user
      @company_user = UserCompany.find_by(company_id: @company.id, user_id: @user.id)
    end

    def working_time?
      @user.working_times.where(company_id: @company.id)
    end
  end
  # rubocop:enable Style/Documentation
end
