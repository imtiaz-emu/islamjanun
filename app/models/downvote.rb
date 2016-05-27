class Downvote < ActiveRecord::Base
  belongs_to :downvotable, polymorphic: true
  belongs_to :user
end
