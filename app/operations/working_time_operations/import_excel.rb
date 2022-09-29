# frozen_string_literal: true

# rubocop:disable Style/Documentation
module WorkingTimeOperations
  require 'securerandom'

  class ImportExcel
    def initialize(params)
      @day_in_week = params[:day_in_week]
      @file = params[:file]
      @company_id = params[:company_id]
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def execute
      spreadsheet = HandleExcelService.new(@file).open_spreadsheet
      header = []
      company = Company.find_by_id(@company_id)

      return { succeed: 'fail', message: 'Company Not Found'} unless company.present?

      company_users = company&.users
      @week_id = check_week(@day_in_week)
      @uuid = SecureRandom.uuid
      company_rate = company.rates&.current_using.present? ? company.rates&.current_using : nil

      ActiveRecord::Base.transaction do
        create_rate_setting(company_rate)
        (1..spreadsheet.last_row).each do |i|
          row = spreadsheet.row(i)
          header = row.map{ _1&.downcase&.strip } if row.include?('EMPLOYEES NAME')

          next unless header.present? && row[0].present? && row[1].present?

          row = Hash[[header, row].transpose]
          user = company_users&.find_by_display_name(row['employees name'].downcase)

          rate = user&.rates&.where(company_id: @company_id).present? ? user.rates.where(company_id: @company_id).current_using : company_rate

          create_working_time(rate, row, user)
        end
      end

      { succeed: true }
    rescue StandardError, AnotherError => e
      {
        succeed: 'fail',
        message: e.inspect
      }
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    def check_week(date)
      fd_of_week = date.to_date.beginning_of_week.strftime('%d/%m/%Y')
      week = Week.find_by_from_date(fd_of_week)

      return week.id if week.present?

      Week.create(
        from_date: fd_of_week,
        to_date: (date.to_date.end_of_week - 1.day).strftime('%d/%m/%Y')
      ).id
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def create_working_time(rate, row, user)
      tth = WorkingTimeService.new(row).total_working_hours
      reg_h = tth > 40 ? 40 : tth
      ot_h = [(tth - 40), 0].max
      internal_regular = rate&.internal_regular.to_i * reg_h
      internal_ot = rate&.internal_ot.to_i * ot_h
      external_regular = rate&.external_regular.to_i * reg_h
      external_ot = rate&.external_ot.to_i * ot_h

      WorkingTime.create(
        uuid: @uuid,
        rate_id: rate&.id,
        company_id: @company_id,
        user_id: user.present? ? user.id : nil,
        week_id: @week_id,
        display_name: row['employees name']&.downcase,
        monday: row['mon'],
        tuesday: row['tue'],
        wednesday: row['wed'],
        thursday: row['thu'],
        friday: row['fri'],
        saturday: row['sat'],
        e_ot_money: external_ot,
        e_reg_money: external_regular,
        i_ot_money: internal_ot,
        i_reg_money: internal_regular,
        total_hours: tth
      )
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def create_rate_setting(rate)
      RateSetting.create!(
        rate_id: rate&.id,
        wkt_uuid: @uuid
      )
    end
  end
end
# rubocop:enable Style/Documentation
