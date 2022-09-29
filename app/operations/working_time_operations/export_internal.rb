# frozen_string_literal: true

# rubocop:disable Style/Documentation
module WorkingTimeOperations
  class ExportInternal
    def initialize(params)
      @params = params
    end

    # params includes
    #   workingtime.uuid
    #   company_id
    # rubocop:disable Style/MethodLength
    # rubocop:disable Style/AbcSize
    def execute
      count = 0
      table = []
      user_rates
      rate

      working_times.each do |row|
        reg = row.total_hours
        ot = 0
        gross = row.i_reg_money + row.i_ot_money
        row_rate = row.user_id.present? ? @user_rates[row.rate_id].first : @rate

        if row.total_hours > 40
          reg = 40
          ot = row.total_hours - 40
        end

        count += 1
        table << [
          count,
          row.display_name&.upcase,
          reg,
          ot,
          row.total_hours,
          row_rate&.internal_regular,
          row_rate&.internal_ot,
          gross.ceil
        ]
      end

      {
        succeed: true,
        file_name: file_name,
        info: info,
        header: header,
        table: table
      }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Style/AbcSize
    # rubocop:enable Style/MethodLength

    private

    def company
      Company.find_by_id(@params[:company_id])
    end

    def working_times
      WorkingTime.where(uuid: @params[:uuid])
    end

    def week
      working_times.first&.week
    end

    def rate
      @rate = RateSetting.find_by_wkt_uuid(@params[:uuid])&.rate
    end

    def user_rates
      user_ids = working_times.pluck(:rate_id).uniq

      @user_rates = Rate.where(id: user_ids).group_by(&:id)
    end

    def info
      [
        [nil, 'PAYOUT'],
        [nil, "#{week.from_date} to #{week.to_date}"]
      ]
    end

    def header
      ['', 'EMPLOYEES NAME', 'REG', 'OT', 'TTH', 'RATE', 'OT RATE', 'GROSS']
    end

    def file_name
      "PAYOUT-#{company.display_name}-(#{week.from_date} - #{week.to_date}).xlsx"
    end
  end
  # rubocop:enable Style/Documentation
end
