class AddTokenToMails < ActiveRecord::Migration
  def change
    add_column :mails, :token, :string
  end
end
