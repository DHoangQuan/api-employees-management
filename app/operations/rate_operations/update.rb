# frozen_string_literal: true

module RateOperations
  # rubocop:disable Style/Documentation
  class Update
    def initialize(params)
      @params = params
      @resource_id = params[:resource_id]
      @type = params[:type]
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      resource_object = @type.capitalize.constantize.find_by_id(@resource_id)

      return { success: 'fail', message: "There no #{@type.capitalize}" } unless resource_object.present?

      status = resource_object.rate.update(
        internal_regular: @params[:internal_regular],
        internal_ot: @params[:internal_ot],
        external_regular: @params[:external_regular],
        external_ot: @params[:external_ot],
        status: Rate::COLUMN_STATUS[:edited]
      )

      return { success: true } if status

      {
        success: 'fail',
        message: 'Update failed'
      }
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
