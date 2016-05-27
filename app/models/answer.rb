class Answer < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :question
  has_many :upvotes, as: :upvotable
  has_many :downvotes, as: :downvotable
  has_many :comments, as: :commentable

  before_destroy :check_downvotes_present

  def check_votes_present
    if self.downvotes.count > 0
      errors.add(:base, 'This answer cannot be deleted because of downvotes.')
      return false
    end
  end
end
