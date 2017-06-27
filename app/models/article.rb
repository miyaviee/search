class Article < ActiveRecord::Base
  include Elasticsearch::Model

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

  after_commit on: [:create] do
    __elasticsearch__.index_document if self.id
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document if self.id
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document if self.id
  end

  has_many :article_contents
end
