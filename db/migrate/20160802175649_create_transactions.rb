class CreateTransactions < ActiveRecord::Migration[5.0]
  # http://edgeguides.rubyonrails.org/active_record_postgresql.html#enumerated-types
  def up
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    execute <<-SQL
      CREATE TYPE transaction_status AS ENUM ('approved', 'rejected', 'pending');
    SQL

    create_table :transactions, force: true do |t|
      t.uuid    :identifier
      t.float   :geo,    array: true #`geo` POINT DEFAULT NULL,
      t.column  :status, :transaction_status, default: 'approved'
      t.text    :desc #varchar(512) DEFAULT NULL

      t.integer :pain_type                #int NOT NULL,
      t.integer :transaction_amount_cents #float NOT NULL,
      t.integer :fee_amount_cents         #float NOT NULL,

      t.string :sender_account_number   #CHAR(36) NOT NULL,
      t.string :sender_bank_number      #CHAR(36) NOT NULL,
      t.string :receiver_account_number #CHAR(36) NOT NULL,
      t.string :receiver_bank_number    #CHAR(36) NOT NULL,
      t.string :status

      t.timestamps
    end
  end

  # NOTE: It's important to drop table before dropping enum.
  def down
    drop_table :transactions

    execute <<-SQL
      DROP TYPE transaction_status;
    SQL
  end
end
