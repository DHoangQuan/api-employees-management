# frozen_string_literal: true

module CompanyOperations
  # rubocop:disable Style/Documentation
  class Create
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def execute
      company = Company.new(
        email: @params[:email]&.downcase,
        name: @params[:name]&.downcase,
        display_name: @params[:display_name]&.downcase,
        phone_number: @params[:phone_number],
        address1: @params[:address1],
        address2: @params[:address2],
        tax: @params[:tax],
        website: @params[:website],
        note: @params[:note]
      )

      return { succeed: 'fail', message: company.errors.objects.first.full_message } unless company.valid?

      company.save

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Style/Documentation
end
