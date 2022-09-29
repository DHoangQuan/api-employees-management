# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  email: 'lanvi1104@gmail.com',
  password: 'Lanvi2013?',
  display_name: 'Lan Vi',
  first_name: 'Lan',
  last_name: 'Nguyen',
  role: User::ROLES[:admin],
  allow_login: true
)

User.create!(
  email: 'hoangquan1097@gmail.com',
  password: '@Z911university',
  display_name: 'Quan',
  first_name: 'Quan',
  last_name: 'Dinh',
  role: User::ROLES[:supper_admin],
  allow_login: true
)
