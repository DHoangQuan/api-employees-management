# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class Index
    def initialize(params)
      @params = params
    end

    def execute
      # for api
      # Company.all.paginate(page: @params[:page], per_page: 10)

      Company.all.order(created_at: :DESC)
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end

  end
  # rubocop:enable Style/Documentation
end
