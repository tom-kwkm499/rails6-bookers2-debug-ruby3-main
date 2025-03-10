class SearchesController < ApplicationController

  def search
    @query = params[:query]
    @search_type = params[:search_type]  # ユーザー検索 or 投稿検索
    @match_type = params[:match_type]    # 完全一致, 前方一致, 後方一致, 部分一致

    if @search_type == 'User'
      @results = User.search_by_name(@query, @match_type)
    elsif @search_type == 'Book'
      @results = Book.search_by_title(@query, @match_type)
    else
      @results = []
    end

    render 'searches/search_results'
  end

end
