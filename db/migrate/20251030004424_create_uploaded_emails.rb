class CreateUploadedEmails < ActiveRecord::Migration[7.2]
  def change
    create_enum :email_status, [ "queued", "processing", "fail", "success" ]

    create_table :uploaded_emails do |t|
      t.string :filename
      t.string :from
      t.string :to
      t.enum :status, enum_type: "email_status", null: false, default: :queued

      t.timestamps
    end
  end
end
