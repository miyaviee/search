class ArticlesController < ApplicationController
  def index
    s3 = Aws::S3::Client.new(
      region: 'ap-notrheast-1',
      credentials: Aws::Credentials.new('test', 'test'),
      endpoint: 'http://localhost:4568',
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
