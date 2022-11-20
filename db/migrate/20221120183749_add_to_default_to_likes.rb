class AddToDefaultToLikes < ActiveRecord::Migration[7.0]
  def change
    change_column :companies, :likes, :bigint, :default => 0
  end
end
