# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class Update
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      status = company.update!(
        email: @params[:email]&.downcase,
        name: @params[:name]&.downcase,
        display_name: @params[:display_name]&.downcase,
        phone_number: @params[:phone_number],
        address1: @params[:address1],
        address2: @params[:address2],
        tax: @params[:tax],
        website: @params[:website],
        name_by_print_on_checks: @params[:name_by_print_on_checks],
        note: @params[:note]
      )

      return { success: 'fail', message: 'update failed' } unless status

      { success: true }
    rescue StandardError, AnotherError => e
      {
        success: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength

    private

    def company
      Company.find_by_id(@params[:id])
    end
  end
  # rubocop:enable Style/Documentation
end
