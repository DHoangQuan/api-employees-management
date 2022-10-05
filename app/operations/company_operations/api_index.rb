# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class ApiIndex
    def initialize(params)
      @params = params
    end

    def execute
      Company.all.paginate(page: @params[:page], per_page: 10)
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
  end
  # rubocop:enable Style/Documentation
end
