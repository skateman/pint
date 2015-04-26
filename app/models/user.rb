class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  has_many :presentations
  has_many :sessions
end
