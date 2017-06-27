class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mapping dynamic: false do
      indexes :title, analyzer: 'kuromoji'
      indexes :description, analyzer: 'kuromoji'
    end
  end

  def search keyword
    search_definition = Elasticsearch::DSL::Search.search {
      query {
        if keyword.present?
          multi_match {
            query keyword
            fields %{title description}
          }
        else
          match_all
        end
      }
    }

    __elasticsearch__.search search_definition
  end

  has_many :article_contents
end
