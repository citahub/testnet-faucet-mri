class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      # save one copy of addresses to receive coins
      t.string :addr

      t.timestamps
    end
  end
end
