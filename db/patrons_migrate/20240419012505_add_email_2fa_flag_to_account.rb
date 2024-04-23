class AddEmail2faFlagToAccount < ActiveRecord::Migration[7.0]
  def up
    safety_assured do
      execute <<-SQL
        ALTER TABLE accounts ADD COLUMN email_2fa_flag ENUM('y', 'n') default 'y' AFTER user_id;
      SQL
    end
  end

  def down
    remove_column :accounts, :email_2fa_flag
  end
end
