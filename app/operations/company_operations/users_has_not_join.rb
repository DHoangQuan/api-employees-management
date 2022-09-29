# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class UsersHasNotJoin
    def initialize(params)
      @params = params
    end

    def execute
      return { succeed: 'fail', message: 'Company Not Found' } unless company.present?

      users = User.not_admin.where.not(id: company_users.pluck(:id)).select(:id, :display_name)

      {
        succeed: true,
        users: users
      }
    end

    private

    def company
      @company = Company.find_by_id(@params[:id])
    end

    def company_users
      @company.users
    end
  end
  # rubocop:enable Style/Documentation
end
