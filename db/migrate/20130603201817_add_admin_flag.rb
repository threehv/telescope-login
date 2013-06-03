class AddAdminFlag < ActiveRecord::Migration
  def change
    add_column :masq_accounts, :admin, :boolean, default: false
  end
end
