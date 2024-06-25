# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 50.times do |i|
#   unless Task.find_by(title: "TaskTEST#{i+1}")
#   Task.create!(title:"TaskTEST#{i+1}", content:"SEEDで作成#{i+1}")
#   end
# end

require 'factory_bot_rails'

FactoryBot.create_list(:task, 3) unless Task.find_by(title: "TEST")
FactoryBot.create_list(:second_task, 3) unless Task.find_by(title: "TEST2")
FactoryBot.create_list(:third_task, 4) unless Task.find_by(title: "TEST3")