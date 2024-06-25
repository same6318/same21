# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


3.times do |i|
  unless Task.find_by(title: "First_task#{i+1}")
  Task.create!(
  title:"First_task#{i+1}",
  content:"SEEDで作成#{i+1}",
  deadline_on: "2024-02-18",
  priority: 1,
  status: 0 )
  end
end

3.times do |i|
  unless Task.find_by(title: "Second_task#{i+1}")
  Task.create!(
  title:"Second_task#{i+1}",
  content:"SEEDで作成#{i+1}",
  deadline_on: "2024-02-17",
  priority: 2,
  status: 1 )
  end
end

4.times do |i|
  unless Task.find_by(title: "Third_task#{i+1}")
  Task.create!(
  title:"Third_task#{i+1}",
  content:"SEEDで作成#{i+1}",
  deadline_on: "2024-02-16",
  priority: 0,
  status: 2 )
  end
end


# require 'factory_bot_rails'

# FactoryBot.create_list(:task, 3) unless Task.find_by(title: "TEST")
# FactoryBot.create_list(:second_task, 3) unless Task.find_by(title: "TEST2")
# FactoryBot.create_list(:third_task, 4) unless Task.find_by(title: "TEST3")
#理想的な使用方法ではないので、消す

