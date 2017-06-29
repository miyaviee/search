class Article < ActiveRecord::Base
  include Searchable

  has_many :article_contents
end
