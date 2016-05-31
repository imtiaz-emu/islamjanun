class SearchController < ApplicationController

  layout 'member'

  def search

    # only search if keyword has been entered
    if params[:keywords].nil? || params[:keywords].empty?
      @hits = []
    else
      @search = Question.search do
        fulltext params[:keywords] do
          highlight :description
        end
        facet :tag_list

        # tags, AND'd
        if params[:tag].present?
          all_of do
            params[:tag].each do |tag|
              with(:tag_list, tag)
            end
          end
        end

      end
      @hits = @search.hits

    end
  end
end