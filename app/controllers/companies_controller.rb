# frozen_string_literal: true

# rubocop:disable Style/Documentation
class CompaniesController < ApplicationController
  def index
    @companies = CompanyOperations::Index.new(params).execute
  end

  def create
    status = CompanyOperations::Create.new(params).execute

    redirect_to action: :index if status[:succeed]
  end

  def show
    @company = CompanyOperations::Show.new(params).execute
    @company_users = @company&.users
    @last_import = WorkingTimeOperations::LatestImport.new(params[:id]).execute
    @rate_setting = RateSettingOperations::Show.new(wkt_uuid: @last_import.first&.uuid).execute
  end

  def update
    status = CompanyOperations::Update.new(params).execute

    redirect_to company_path(params[:id]) if status[:succeed]
  end

  def kick_user
    status = CompanyOperations::KickUser.new(params).execute

    redirect_to company_path(params[:id]) if status[:succeed]
  end

  def users_has_not_join
    status = CompanyOperations::UsersHasNotJoin.new(params).execute

    @company_id = params[:id]
    @users = status[:users]
  end

  def add_users
    status = CompanyOperations::AddUsers.new(params).execute

    redirect_to company_path(params[:id]) if status[:succeed]
  end
end
# rubocop:enable Style/Documentation
