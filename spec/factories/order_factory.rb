FactoryBot.define do

  factory :order do
    total 100.00

    association :user
    association :product
  end

end
