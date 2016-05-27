class Answer < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :question

  # before_destroy :check_votes_present
  #
  # def check_votes_present
  #
  # end
end
