# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class LatestImport
    def initialize(company_id)
      @company_id = company_id
    end

    def execute
      time_with_company = WorkingTime.where(company_id: @company_id)
      last_row = time_with_company.last

      time_with_company.where(uuid: last_row&.uuid).order(:created_at)
    end
  end
  # rubocop:enable Style/Documentation
end
