class Answer < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :question
  has_many :upvotes, as: :upvotable
  has_many :downvotes, as: :downvotable

  # before_destroy :check_votes_present
  #
  # def check_votes_present
  #
  # end
end
