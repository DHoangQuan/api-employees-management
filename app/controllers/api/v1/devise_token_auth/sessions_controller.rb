# frozen_string_literal: true

module Api
  module V1
    module DeviseTokenAuth
      class SessionsController < ::DeviseTokenAuth::SessionsController
        skip_before_action :verify_authenticity_token

        def create
          resource = User.find_by(email: resource_params[:email].downcase)

          if resource.present? && resource.allow_login
            rs = resource.valid_password?(resource_params[:password])

            if rs
              super do |obj|
                return render json: success_respon(obj)
              end
            end

            render json: {
              success: false,
              errors: 'Invalid login credentials. Please try again'
            }, status: 401
          else
            render json: {
              success: false,
              errors: 'Not Found User'
            }, status: 401
          end
        end

        private

        def success_respon(resource)
          {
            user: resource.slice(:display_name),
            uid: resource.uid,
            'access-token': @token.token,
            client: @token.client,
            expiry: @token.expiry
          }
        end
      end
    end
  end
end
