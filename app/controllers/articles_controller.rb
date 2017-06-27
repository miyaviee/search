class ArticlesController < ApplicationController
  def index
    render json: { msg: 'Hello, World' }
  end
end
