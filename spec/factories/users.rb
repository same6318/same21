FactoryBot.define do
  factory :user do
    name { "User" }
    email { "User@test.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end

  factory :user2, class: User do
    name { "" }
    email { "User2@test.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end

  factory :user3, class: User do
    name { "User3" }
    email { "" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end

  factory :user4, class: User do
    name { "User4" }
    email { "User4@test.com" }
    password { "12345" }
    password_confirmation { "12345" }
    admin { false }
  end

  factory :user5, class: User do
    name { "User5" }
    email { "User5@test.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { true }
  end
end