module QuestionsHelper

  def user_can_give_answer(question)
    return false if !current_user.present?
    answer = Answer.where(:user_id => current_user.id, :question_id => question.id)
    return current_user.present? && !answer.present?
  end

end
