class Question < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :answers

  validates :content, presence: true

  paginates_per 20

  accepts_nested_attributes_for :answers
  accepts_nested_attributes_for :comments
end
