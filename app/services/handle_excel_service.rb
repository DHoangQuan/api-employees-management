# frozen_string_literal: true

# rubocop:disable Style/Documentation
class HandleExcelService
  require 'csv'

  def initialize(file = nil)
    @file = file
  end

  def open_spreadsheet
    case File.extname(@file.original_filename)
    when '.csv' then Roo::CSV.new(@file.path)
    when '.xls' then Roo::Excel.new(@file.path)
    when '.xlsx' then Roo::Excelx.new(@file.path)
    else raise "Unknown file type: #{@file.original_filename}"
    end
  end

  def export_csv(table, header_table = nil, info_header = nil)
    CSV.generate do |csv|
      info_header.each do |e|
        csv << [e]
      end
      csv << [] if info_header.present?
      csv << header_table
      table.each do |row|
        csv << row
      end
    end
  end
end
# rubocop:enable Style/Documentation
