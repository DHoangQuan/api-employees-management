# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class Index
    def initialize(params, company_id = nil)
      @params = params
      @company_id = company_id
    end

    def execute
      # for api
      # users = User.not_admin.order(created_at: :DESC).paginate(page @params[:page], per_page: 10)
      users = User.not_admin.order(created_at: :DESC)

      users.joins(:user_companies).where(user_companies: { company_id: @company_id }) if @company_id.present?

      users
    end
  end
  # rubocop:enable Style/Documentation
end
