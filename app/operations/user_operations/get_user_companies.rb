# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class GetUserCompanies
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      return { succeed: 'fail', message: 'User Not Found' } unless user.present?

      join_company_ids = user.companies.pluck(:id)
      @companies = Company.where.not(id: join_company_ids)

      {
        succeed: true,
        companies: @companies
      }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end

    private

    def user
      User.find_by_id(@params[:id])
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
