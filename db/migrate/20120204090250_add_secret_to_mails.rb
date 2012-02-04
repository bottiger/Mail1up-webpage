class AddSecretToMails < ActiveRecord::Migration
  def change
    add_column :mails, :secret, :string
  end
end
