# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class Show
    def initialize(params)
      @params = params
    end

    def execute
      Company.find_by_id(@params[:id])
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
  end
  # rubocop:enable Style/Documentation
end
