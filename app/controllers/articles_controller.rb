class ArticlesController < ApplicationController
  def index
    s3 = Aws::S3::Client.new Rails.application.config.s3
    unless s3.head_bucket bucket: 'test'
      s3.create_bucket({
        bucket: 'test',
      })
    end
    render json: Article.search(params[:q]).records
  end
end
