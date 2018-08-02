class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product, touch: true

  validates :user, presence: true
  validates :product, presence: true
  validates :body, presence: true
  validates :rating, numericality: {only_integer: true}


  scope :rating_desc, -> { order(rating: :desc) }
  scope :rating_asc, -> { order(rating: :asc) }
end
