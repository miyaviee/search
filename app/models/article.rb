class Article < ActiveRecord::Base
  has_many :article_contents
end
