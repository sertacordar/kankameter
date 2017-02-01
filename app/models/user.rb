class User < ApplicationRecord
  has_many :entries
  has_many :favourites, through: :entries
end
