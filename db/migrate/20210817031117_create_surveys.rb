class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :code
      t.string :name
      t.string :liff_id
      t.string :title
      t.text :description
      t.longtext :action
      t.text :success_message
      t.string :status, default: 'enabled'
      t.boolean :is_publish, default: false
      t.boolean :multiple_answers, default: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
