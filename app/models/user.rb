class User < ApplicationRecord
  has_one :wallet, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
