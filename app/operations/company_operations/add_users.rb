# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class AddUsers
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      return { success: 'fail', message: 'Company Not Found' } unless company.present?
      return { success: 'fail', message: 'Users Not Found' } unless users.present?
      return { success: 'fail', message: 'Some Users not existing' } if @users.size != @params[:user_ids].size

      @params[:user_ids].each do |user_id|
        UserCompany.create!(
          company_id: @company.id,
          user_id: user_id
        )
      end

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

    def users
      @users = User.where(id: @params[:user_ids])
    end
  end
  # rubocop:enable Style/Documentation
end
