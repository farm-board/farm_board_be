class AddPaymentTypeToPostings < ActiveRecord::Migration[7.1]
  def change
    add_column :postings, :payment_type, :string
  end
end
