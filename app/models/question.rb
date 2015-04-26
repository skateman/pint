class Question < ActiveRecord::Base
  belongs_to :presentation
  has_many :answers
end
