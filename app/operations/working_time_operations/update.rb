# frozen_string_literal: true

module WorkingTimeOperations
  # rubocop:disable Style/Documentation
  class Update
    def initialize(params)
      @params = params
    end

    def execute
      return { succeed: 'fail', message: e.inspect } unless working_time.present?

      update_wkt

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end

    private

    def working_time
      WorkingTime.find_by_id(@params[:id])
    end

    def tth
      return @params[:total_hours].to_i if @params[:total_hours].present?

      WorkingTimeService.new(@params).total_working_hours
    end

    def rate
      RateSetting.find_by_wkt_uuid(working_time.uuid)&.rate
    end

    def external_ot
      return @params[:e_ot_money].to_i if @params[:e_ot_money].present?

      ot = tth > 40 ? tth - 40 : 0

      ot * rate&.external_ot
    end

    def external_regular
      return @params[:e_reg_money] if @params[:e_reg_money].present?

      reg = tth > 40 ? 40 : tth

      reg * rate&.external_regular
    end

    def internal_ot
      return @params[:i_ot_money] if @params[:i_ot_money].present?

      ot = tth > 40 ? tth - 40 : 0

      ot * rate&.internal_ot
    end

    def internal_regular
      return @params[:i_reg_money] if @params[:i_reg_money].present?

      reg = tth > 40 ? 40 : tth

      reg * rate&.internal_regular
    end

    # rubocop:disable Metrics/MethodLength
    def update_wkt
      working_time.update!(
        display_name: @params[:display_name],
        monday: @params[:monday],
        tuesday: @params[:tuesday],
        wednesday: @params[:wednesday],
        thursday: @params[:thursday],
        friday: @params[:friday],
        saturday: @params[:saturday],
        e_ot_money: external_ot,
        e_reg_money: external_regular,
        i_ot_money: internal_ot,
        i_reg_money: internal_regular,
        total_hours: tth
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
