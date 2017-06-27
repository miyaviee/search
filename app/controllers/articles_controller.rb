class ArticlesController < ApplicationController
  def index
    render json: Article.search(params[:q]).records
  end
end
