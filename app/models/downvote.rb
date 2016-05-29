class Downvote < ActiveRecord::Base
  belongs_to :downvotable, polymorphic: true
  belongs_to :user

  after_create :point_deletion
  after_destroy :point_addition

  private
  def point_addition
    profile = self.downvotable.user.profile
    if self.downvotable.is_a?(Question)
      profile.update_column(:points, profile.points + 3)
    else
      profile.update_column(:points, profile.points + 4)
    end
  end

  def point_deletion
    profile = self.downvotable.user.profile
    if self.downvotable.is_a?(Question)
      profile.update_column(:points, profile.points - 3)
    else
      profile.update_column(:points, profile.points - 4)
    end
  end
end
