class PagesController < ApplicationController

  layout 'member'

  def tags
    @tags = ActsAsTaggableOn::Tag.all.map{|t| [Question.tagged_with(t.name).count, t.name]}.sort.reverse!
  end

  def rules

  end

end
