class Article < ActiveRecord::Base
  include Elasticsearch::Model

  settings do
    mapping dynamic: false do
      indexes :title, analyzer: 'kuromoji'
      indexes :description, analyzer: 'kuromoji'
      indexes :article_contents, type: 'nested' do
        indexes :title, analyzer: 'kuromoji'
        indexes :body, analyzer: 'kuromoji'
      end
    end
  end

  def search keyword
    search_definition = Elasticsearch::DSL::Search.search {
      query {
        if keyword.present?
          bool {
            should {
                multi_match {
                  query keyword
                  fields %{title description}
                }
                nested {
                  path article_contents
                  query {
                    multi_match keyword
                    fields %{article_contents.title article_contents.body}
                  }
                }
            }
          }
        else
          match_all
        end
      }
    }

    __elasticsearch__.search search_definition
  end

  def as_indexed_json(option={})
    article_attrs = {
      title: self.title,
      description: self.description,
    }
    article_attrs[:article_contents] = self.article_contents.map do |article_content|
      {
        title: article_content.title,
        body: article_content.body,
      }
    end

    article_attrs.as_json
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
