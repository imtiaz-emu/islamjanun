class PagesController < ApplicationController

  layout 'member'

  def tags
    @tags = ActsAsTaggableOn::Tag.all.map{|t| [Question.tagged_with(t.name).count, t.name]}.sort.reverse!
  end

  def rules

  end

  def users
    @users = User.includes(:profile).map{|u| u if !u.role?(:super_admin)}.delete_if{|u| u == nil}
  end

end
