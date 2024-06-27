# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name:"seedUser",email:"seed1@sample.com",admin: false, password:"123456",password_confirmation:"123456")
admin = User.create!(name:"seedUser",email:"seed2@sample.com",admin: true, password:"123456",password_confirmation:"123456")


50.times do |i|
  unless user.tasks.find_by(title: "user_task#{i+1}")
  user.tasks.create!(
  title:"user_task#{i+1}",
  content:"SEEDで作成#{i+1}",
  deadline_on: "2024-06-27",
  priority: 1,
  status: 0,
  user_id: user.id )
  end
end

50.times do |i|
  unless admin.tasks.find_by(title: "admin_task#{i+1}")
  admin.tasks.create!(
  title:"admin_task#{i+1}",
  content:"SEEDで作成#{i+1}",
  deadline_on: "2024-06-28",
  priority: 2,
  status: 1,
  user_id: admin.id )
  end
end


# require 'factory_bot_rails'

# FactoryBot.create_list(:task, 3) unless Task.find_by(title: "TEST")
# FactoryBot.create_list(:second_task, 3) unless Task.find_by(title: "TEST2")
# FactoryBot.create_list(:third_task, 4) unless Task.find_by(title: "TEST3")
#理想的な使用方法ではないので、消す

