class AddToCompaniesName < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :name, :string
  end
end
