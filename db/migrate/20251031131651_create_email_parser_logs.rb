class CreateEmailParserLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :email_parser_logs do |t|
      t.string :level
      t.text :error_message
      t.jsonb :extracted_data
      t.references :uploaded_email, null: false, foreign_key: true

      t.timestamps
    end
  end
end
