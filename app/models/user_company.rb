# frozen_string_literal: true

# == Schema Information
#
# Table name: user_companies
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_user_companies_on_user_id_and_company_id  (user_id,company_id)
#
class UserCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
