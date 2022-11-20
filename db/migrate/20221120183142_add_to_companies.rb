class AddToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :api_id, :string
    add_column :companies, :likes, :bigint
  end
end
