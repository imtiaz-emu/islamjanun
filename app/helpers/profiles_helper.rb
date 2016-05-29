module ProfilesHelper

  def individual_points(obj)
    if obj.is_a?(Question)
      obj.upvotes.count * 10 - obj.downvotes.count * 3 + (obj.answers.find_by(accepted: true).present? ? 5 : 0)
    else
      obj.upvotes.count * 15 - obj.downvotes.count * 4 + (obj.accepted ? 20 : 0)
    end
  end

  def total_points_distribution(user)
    results = []
    results << user.questions.reduce(0) { |sum,ques| sum + individual_points(ques) }
    results << user.answers.reduce(0) { |sum,ans| sum + individual_points(ans) }
    return results
  end

end
