FactoryBot.define do

  factory :product do
    name "Product"
    description "This is a product"
    colour "colour"
    price "100"

    factory :product_with_comments do
      transient do
        comments_count 3
      end

      after(:build) do |product, evaluator|
        create_list(:comment, evaluator.comments_count, product: product)
      end
    end
  end

end
