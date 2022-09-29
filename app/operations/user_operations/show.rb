# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class Show
    def initialize(params)
      @params = params
    end

    def execute
      User.find_by_id(@params[:id])
    end
  end
  # rubocop:enable Style/Documentation
end
