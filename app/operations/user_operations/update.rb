# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class Update
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      status = user.update!(
        email: @params[:email]&.downcase,
        first_name: @params[:first_name]&.downcase,
        middle_name: @params[:middle_name]&.downcase,
        last_name: @params[:last_name]&.downcase,
        display_name: @params[:display_name]&.downcase,
        phone_number: @params[:phone_number],
        address1: @params[:address1],
        address2: @params[:address2],
        note: @params[:note]
      )

      return { succeed: 'fail', message: 'update failed' } unless status

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/MethodLength

    private

    def user
      User.find_by_id(@params[:id])
    end
  end
  # rubocop:enable Style/Documentation
end
