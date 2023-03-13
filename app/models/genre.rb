class Genre < ApplicationRecord
  has_many:items,dependent: :delete
end
