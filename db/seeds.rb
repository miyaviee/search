# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(1..5).each do |n|
  Article.create(title: "テスト#{n}", description: "本文#{n}")
  (1..5).each do |i|
    ArticleContent.create(article_id: n, title: "コンテンツ#{n}#{i}", body: "コンテンツ本文#{n}#{i}")
  end
end
