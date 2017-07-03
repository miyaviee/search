class ArticlesController < ApplicationController
  def index
    credentials = Aws::Credentials.new ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY']
    s3 = Aws::S3::Client.new(
      region: 'ap-notrheast-1',
      credentials: credentials,
      endpoint: ENV['S3_ENDPOINT'],
      force_path_style: true
    )

    unless s3.head_bucket bucket: 'test'
      s3.create_bucket({
        bucket: 'test',
      })
    end
    render json: Article.search(params[:q]).records
  end
end
