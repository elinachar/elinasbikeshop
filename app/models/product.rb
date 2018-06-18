class Product < ApplicationRecord
    has_many :orders

    def self.search(search_term)
      if Rails.env.development?
        where("name LIKE ?", "%#{search_term}%")
      elsif Rails.env.production?
        where("name ILIKE ?", "%#{search_term}%")
      end
    end
end
