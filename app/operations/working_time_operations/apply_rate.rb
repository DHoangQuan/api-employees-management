# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class ApplyRate
    def initialize(params)
      @params = params
    end

    # rubocop:disable Style/AbcSize
    # rubocop:disable Style/MethodLength
    def execute
      rate_setting.update(rate_id: @params[:rate_id].to_i)
      rate = rate_setting.rate

      list_wkt.each do |row|
        reg_h = row.total_hours > 40 ? 40 : row.total_hours
        ot_h = [(row.total_hours - 40), 0].max
        i_reg_money = reg_h * rate.internal_regular
        i_ot_money = ot_h * rate.internal_ot
        e_reg_money = reg_h * rate.external_regular
        e_ot_money = ot_h * rate.external_ot

        status = row.update(
          i_reg_money: i_reg_money,
          i_ot_money: i_ot_money,
          e_reg_money: e_reg_money,
          e_ot_money: e_ot_money
        )

        { succeed: 'fail', message: 'apply rate fail' } unless status
      end

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Style/MethodLength
    # rubocop:enable Style/AbcSize

    private

    def rate_setting
      RateSetting.find_by_wkt_uuid(@params[:wkt_uuid])
    end

    def list_wkt
      WorkingTime.where(uuid: @params[:wkt_uuid])
    end
  end
  # rubocop:enable Style/Documentation
end
