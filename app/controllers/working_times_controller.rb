# frozen_string_literal: true

# rubocop:disable Style/Documentation
class WorkingTimesController < ApplicationController
  require 'csv'

  # rubocop:disable Metrics/AbcSize
  def index
    @company = CompanyOperations::Show.new(id: params[:company_id]).execute
    status = WorkingTimeOperations::Index.new(params).execute

    @working_times = status[:working_times]
    @selected_month = params[:day_in_month].present? ? params[:day_in_month].to_date.month : DateTime.now.month
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def import_excel
    status = WorkingTimeOperations::ImportExcel.new(params).execute

    if status[:succeed] == true && params[:history].present?
      return redirect_to working_times_companies_path(company_id: params[:company_id],
                                                      day_in_month: params[:day_in_week])
    end

    redirect_to company_path(params[:company_id]) if status[:succeed] == true
  end
  # rubocop:enable Metrics/AbcSize

  def show
    result = WorkingTimeOperations::Show.new(params).execute

    @working_time = result[:working_time]
  end

  def update
    status = WorkingTimeOperations::Update.new(params).execute

    redirect_to company_path(params[:company_id]) if status[:succeed] == true
  end

  def destroy
    status = WorkingTimeOperations::Destroy.new(params).execute

    redirect_to company_path(params[:company_id]) if status[:succeed] == true
  end

  # destroy all working time by uuid
  def destroy_all
    return unless params[:uuid].present?

    status = WorkingTimeOperations::DestroyAll.new(params).execute

    redirect_to company_path(params[:company_id]) if status[:succeed] == true
  end

  def apply_rate
    status = WorkingTimeOperations::ApplyRate.new(params).execute

    redirect_to company_path(params[:company_id]) if status[:succeed] == true
  end

  def export_origin
    result = WorkingTimeOperations::ExportOrigin.new(params).execute

    return if result[:succeed] == 'fail'

    @info_data = result[:info]
    @header = result[:header]
    @table = result[:table]
    file_name = result[:file_name]

    respond_to do |format|
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{file_name} " }
    end
  end

  # rubocop:disable Style/AbcSize
  def export_salary
    result = WorkingTime::REPORT_TYPE_METHOD[params[:type].to_sym].constantize.new(params).execute

    return if result[:succeed] == 'fail'

    @info_data = result[:info]
    @header = result[:header]
    @table = result[:table]
    file_name = result[:file_name]

    respond_to do |format|
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{file_name} " }
    end
  end
  # rubocop:enable Style/AbcSize

  def list_users
    status = WorkingTimeOperations::ListUsers.new(params).execute

    @user = UserOperations::Show.new(id: params[:user_id]).execute
    @users = status[:users]
    @id = params[:id]
  end

  def assign_users
    status = WorkingTimeOperations::AssignUsers.new(params).execute

    redirect_to company_path(status[:company_id]) if status[:succeed]
  end
end
# rubocop:enable Style/Documentation
