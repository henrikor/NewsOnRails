# -*- encoding : utf-8 -*-
class AddPasswordResetCode < ActiveRecord::Migration
  def self.up
    add_column "norusers", "password_reset_code", :string, :limit => 40
    add_column :norusers, :activation_code, :string, :limit => 40
    add_column :norusers, :activated_at, :datetime

  end

  def self.down
    remove_column "norusers", "password_reset_code" 
    remove_column "norusers", "activation_code"
    remove_column "norusers", "activated_at"

  end
end
