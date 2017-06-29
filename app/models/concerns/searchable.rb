module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']

    mapping dynamic: false do
      indexes :title, analyzer: 'kuromoji'
      indexes :description, analyzer: 'kuromoji'
      indexes :article_contents, type: 'nested' do
        indexes :title, analyzer: 'kuromoji'
        indexes :body, analyzer: 'kuromoji'
      end
    end

    def search keyword
      search_definition = Elasticsearch::DSL::Search.search {
        query {
          if keyword.present?
            query_string {
              query keyword
            }
          else
            match_all
          end
        }
      }

      __elasticsearch__.search search_definition
    end

    def as_indexed_json(option={})
      article_contents = self.article_contents.map do |article_content|
        {
          title: article_content.title,
          body: article_content.body,
        }
      end

      {
        title: self.title,
        description: self.description,
        article_contents: article_contents,
      }.as_json
    end
  end
end
