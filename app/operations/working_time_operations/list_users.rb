# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class ListUsers
    def initialize(params)
      @params = params
    end

    def execute
      return { succeed: 'fail', message: 'Company Not Found' } unless company.present?

      users = user_not_in_wkt.select(:id, :display_name)

      {
        succeed: true,
        users: users
      }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end

    private

    def company
      Company.find_by_id(@params[:company_id])
    end

    def working_times
      WorkingTime.where(uuid: @params[:wkt_uuid])
    end

    def joined_user_ids
      working_times.pluck(:user_id).uniq.compact
    end

    def user_not_in_wkt
      company.users.where.not(id: joined_user_ids)
    end
  end
  # rubocop:enable Style/Documentation
end
