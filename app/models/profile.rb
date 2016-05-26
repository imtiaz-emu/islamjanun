class Profile < ActiveRecord::Base
  belongs_to :user
  mount_uploader :photo, ProfilePhotoUploader

  def name
    if self.full_name.present?
      return self.full_name
    else
      return self.user.first_name
    end
  end
end
