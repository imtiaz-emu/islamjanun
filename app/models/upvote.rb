class Upvote < ActiveRecord::Base
  belongs_to :upvotable, polymorphic: true
  belongs_to :user
end
