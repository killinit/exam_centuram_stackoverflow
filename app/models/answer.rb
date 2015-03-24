class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :comments

  validates :content, presence: true

  accepts_nested_attributes_for :comments
end
