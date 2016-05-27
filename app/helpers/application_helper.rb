module ApplicationHelper

  def upvoted(obj)
    if current_user.present? && obj.upvotes.present?
      return obj.upvotes.pluck(:user_id).include?(current_user.id)
    else
      return false
    end
  end

  def downvoted(obj)
    if current_user.present? && obj.downvotes.present?
      return obj.downvotes.pluck(:user_id).include?(current_user.id)
    else
      return false
    end
  end

end
