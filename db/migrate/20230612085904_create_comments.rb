class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content

      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :parent_comment_id
      t.timestamps
    end

    add_foreign_key :comments, :comments, column: :parent_comment_id
    add_index :comments, :parent_comment_id
  end
end
 