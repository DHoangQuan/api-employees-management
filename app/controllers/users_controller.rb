# frozen_string_literal: true

# rubocop:disable Style/Documentation
class UsersController < ApplicationController
  def index
    @users = UserOperations::Index.new(params).execute
  end

  def create
    status = UserOperations::Create.new(params).execute

    redirect_to action: 'index' if status[:succeed]
  end

  def show
    @user = UserOperations::Show.new(params).execute
    @user_companies = @user.companies.order(created_at: :DESC)
    @personal_rates = @user.rates.where(company_id: @user_companies.pluck(:id), status: Rate::COLUMN_STATUS[:current])&.group_by{ _1.company_id }
    status = UserOperations::History.new(params).execute

    @history = status[:working_times]
    @selected_month = params[:day_in_month].present? ? params[:day_in_month].to_date.month : DateTime.now.month
    @weeks = status[:weeks]
    @companies = Company.where(id: @history.keys)&.group_by(&:id)
  end

  def update
    status = UserOperations::Update.new(params).execute

    redirect_to user_path(params[:id]) if status[:succeed]
  end

  def not_join_companies
    @user = UserOperations::Show.new(params).execute
    status = UserOperations::GetUserCompanies.new(params).execute
    @companies = status[:companies]
  end

  def join_companies
    status = UserOperations::JoinCompanies.new(params).execute

    redirect_to user_path(params[:id]) if status[:succeed]
  end

  def popup_user_rate
    @resource_id = params[:id]
    @company_id = params[:company_id]
    @user_rate = User.find_by_id(@resource_id)
                     .rates
                     .where(company_id: @company_id, status: Rate::COLUMN_STATUS[:current])
                     .first
  end
end
# rubocop:enable Style/Documentation
