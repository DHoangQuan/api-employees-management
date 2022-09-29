# frozen_string_literal: true

module UserOperations
  # rubocop:disable Style/Documentation
  class Create
    def initialize(params)
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def execute
      user = User.new(
        email: @params[:email]&.downcase,
        password: generated_password,
        first_name: @params[:first_name]&.downcase,
        middle_name: @params[:middle_name]&.downcase,
        last_name: @params[:last_name]&.downcase,
        display_name: @params[:display_name]&.downcase,
        phone_number: @params[:phone_number],
        title: @params[:title],
        address1: @params[:address1],
        address2: @params[:address2],
        note: @params[:note],
        role: User::ROLES[:employee]
      )

      return { succeed: 'fail', message: user.errors.objects.first.full_message } unless user.valid?

      user.save

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

    def generated_password
      SecureRandom.hex(8)
    end
  end
  # rubocop:enable Style/Documentation
end
