# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john@example.com" }
    password_digest { "password" }
  end
end
