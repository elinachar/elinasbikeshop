FactoryBot.define do

  sequence(:email) { |n| "user#{n}@mail.com"}

  factory :user do
    email
    password "123456"
    first_name "Simple"
    last_name "User"
    admin false
  end

  factory :admin, class: User do
    email
    password "123456"
    first_name "Admin"
    last_name "User"
    admin true
  end

end
