class Question < ActiveRecord::Base
  belongs_to :user
  has_many  :answers

  before_destroy :check_if_answer_present

  acts_as_taggable_on :tags
  include Impressionist::IsImpressionable
  is_impressionable

  private

  def check_if_answer_present
    if self.answers.count > 0
      errors.add(:base, 'This question cannot be deleted because answers exist.')
      return false
    end
  end

end
