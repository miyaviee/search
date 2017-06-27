class CreateArticleContents < ActiveRecord::Migration
  def change
    create_table :article_contents do |t|
      t.integer :article_id
      t.string :title
      t.text :body

      t.timestamps null: false
    end
  end
end
