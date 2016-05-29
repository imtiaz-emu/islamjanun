class Upvote < ActiveRecord::Base
  belongs_to :upvotable, polymorphic: true
  belongs_to :user

  after_create :point_addition
  after_destroy :point_deletion

  private
  def point_addition
    profile = self.upvotable.user.profile
    if self.upvotable.is_a?(Question)
      profile.update_column(:points, profile.points + 10)
    else
      profile.update_column(:points, profile.points + 15)
    end
  end

  def point_deletion
    profile = self.upvotable.user.profile
    if self.upvotable.is_a?(Question)
      profile.update_column(:points, profile.points - 10)
    else
      profile.update_column(:points, profile.points - 15)
    end
  end

end
