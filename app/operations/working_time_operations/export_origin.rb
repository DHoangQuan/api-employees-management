# frozen_string_literal: true

# rubocop:disable Style/Documentation
module WorkingTimeOperations
  class ExportOrigin
    def initialize(params)
      @params = params
    end

    # params includes
    #   workingtime.uuid
    #   company_id
    # rubocop:disable Style/MethodLength
    def execute
      count = 0
      table = []
      working_times.each do |row|
        count += 1
        table << [
          count,
          row.display_name&.upcase,
          row.monday,
          row.tuesday,
          row.wednesday,
          row.thursday,
          row.friday,
          row.saturday
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
    # rubocop:enable Style/MethodLength

    private

    def file_name
      "#{company.display_name}-(#{week.from_date} - #{week.to_date}).xlsx"
    end

    def company
      Company.find_by_id(@params[:company_id])
    end

    def info
      [
        [nil, company.display_name.upcase],
        [nil, company.address1],
        [nil, "TEL: #{company.phone_number}"],
        [nil, nil, nil, 'TIME SHEET'],
        [nil, "#{week.from_date} - #{week.to_date}"]
      ]
    end

    def header
      ['', 'EMPLOYEES NAME', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
    end

    def working_times
      WorkingTime.where(uuid: @params[:uuid])
    end

    def week
      working_times.first&.week
    end
  end
end
# rubocop:enable Style/Documentation
