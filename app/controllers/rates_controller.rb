# frozen_string_literal: true

# rubocop:disable Style/Documentation
class RatesController < ApplicationController
  def create
    status = RateOperations::Create.new(params).execute

    return redirect_to user_path(params[:resource_id]) if status[:success] && params[:company_id].present?

    redirect_to company_path(params[:resource_id]) if status[:success]
  end

  def update
    status = RateOperations::Update.new(params).execute

    redirect_to company_path(params[:resource_id]) if status[:success]
  end
end
# rubocop:enable Style/Documentation
