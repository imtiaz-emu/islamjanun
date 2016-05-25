class HomeController < ApplicationController
  def index
  end

  def all_tags
    @tags = ActsAsTaggableOn::Tag.all.pluck(:name)
    respond_to do |format|
      format.json { render :json => @tags }
    end
  end
end
