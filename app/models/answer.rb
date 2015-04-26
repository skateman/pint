class Answer < ActiveRecord::Base
  belongs_to :session
  belongs_to :question
end
