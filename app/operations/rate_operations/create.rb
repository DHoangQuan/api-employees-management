# frozen_string_literal: true

module RateOperations
  # rubocop:disable Style/Documentation
  class Create
    def initialize(params)
      @params = params
      @resource_id = params[:resource_id]
      @type = params[:type]
      @resource_object = @type.capitalize.constantize.find_by_id(@resource_id)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def execute
      return { succeed: 'fail', message: "There no #{@type.capitalize}" } unless @resource_object.present?

      company_id = @resource_object.is_a?(User) ? @params[:company_id] : nil

      if existing_rate.present?
        update_rate_to_past
      else
        ActiveRecord::Base.transaction do
          @resources.where(status: Rate::COLUMN_STATUS[:current])
                    .update_all(status: Rate::COLUMN_STATUS[:past])
          rate = @resource_object.rates.new(
            internal_regular: @params[:internal_regular],
            internal_ot: @params[:internal_ot],
            external_regular: @params[:external_regular],
            external_ot: @params[:external_ot],
            status: Rate::COLUMN_STATUS[:current],
            company_id: company_id
          )

          return { succeed: 'fail', message: rate.errors.objects.first.full_message } unless rate.valid?

          rate.save
        end
      end

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    def existing_rate
      @resources = @resource_object.rates.where(
        internal_regular: @params[:internal_regular],
        internal_ot: @params[:internal_ot],
        external_regular: @params[:external_regular],
        external_ot: @params[:external_ot]
      )

      return @resources.where(company_id: @params[:company_id]) if @resource_object.is_a?(User)

      @resources
    end

    def update_rate_to_past
      rates = @resource_object.rates.where(status: Rate::COLUMN_STATUS[:current])
      if @resource_object.is_a?(User)
        rates.where(company_id: @params[:company_id])
             .update_all(status: Rate::COLUMN_STATUS[:past])
      else
        rates.update_all(status: Rate::COLUMN_STATUS[:past])
      end

      @resources.first.update(status: Rate::COLUMN_STATUS[:current])
    end
  end
  # rubocop:enable Style/Documentation
end
