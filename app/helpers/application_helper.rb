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

  def all_comments(obj)
    obj.comments.order('created_at ASC')
  end

  def unique_id_generator(obj)
    if obj.is_a?(Answer)
      'a_' + obj.id.to_s + '-comment-form'
    else
      'q_' + obj.id.to_s + '-comment-form'
    end
  end

end
