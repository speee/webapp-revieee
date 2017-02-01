class Task < ApplicationRecord
  has_many :endpoints, dependent: :destroy

  validates :arn, presence: true
  validates :repository, presence: true, uniqueness: { scope: :pr_number }
  validates :pr_number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :endpoints, presence: true
end
