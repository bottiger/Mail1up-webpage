class AddPrimaryKeyToMails < ActiveRecord::Migration
  def change
    change_table :mails do |t|
      t.remove :mail
      t.string :mail, :unique => true
      t.index :mail
    end
  end
end
