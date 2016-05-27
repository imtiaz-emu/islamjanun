module QuestionsHelper

  def user_can_give_answer(question)
    return false if !current_user.present?
    answer = Answer.where(:user_id => current_user.id, :question_id => question.id)
    return current_user.present? && !answer.present?
  end

  def top_questions(ques_id)
    Question.includes(:upvotes).where.not(id: ques_id).map{|q| [q.impressionist_count, q.upvotes.count, q.title, q.id]}.sort.first(5)
  end

  def related_questions(question)
    Question.where.not(id: question.id).tagged_with(question.tag_list, :any => true)
  end

end
