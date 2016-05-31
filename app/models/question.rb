class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :upvotes, as: :upvotable
  has_many :downvotes, as: :downvotable
  has_many :comments, as: :commentable

  before_destroy :check_if_answer_present

  acts_as_taggable_on :tags
  include Impressionist::IsImpressionable
  is_impressionable

  searchable :auto_index => true, :auto_remove => true do
    text :title, :stored => true
    text :description, :stored => true
    string :tag_list, :multiple => true, :stored => true
  end

  private

  def check_if_answer_present
    if self.answers.count > 0
      errors.add(:base, 'This question cannot be deleted because answers exist.')
      return false
    end
  end

end
