# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class JoinCompanies
    def initialize(params)
      @user_id = params[:id]
      @company_ids = params[:company_ids].uniq
    end

    def execute
      ActiveRecord::Base.transaction do
        user = User.find_by_id(@user_id)
        return { succeed: 'fail', message: 'Not Found' } unless valid_company_ids

        companies.each do |company|
          user.companies << company
        end
      end

      {
        succeed: true
      }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end

    private

    def valid_company_ids
      companies.size == @company_ids.size
    end

    def companies
      Company.where(id: @company_ids)
    end
    # rubocop:enable Style/Documentation
  end
end
