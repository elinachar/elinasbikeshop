FactoryBot.define do

  factory :comment do
    body "This is a comment"
    rating 1

    association :user
    association :product
  end

end
