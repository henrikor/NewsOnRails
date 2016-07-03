# -*- encoding : utf-8 -*-
class AddPasswordResetCode < ActiveRecord::Migration
  def self.up
  create_table "norusers", :force => true do |t|
    t.string    "login"
    t.string    "email"
    t.string    "crypted_password",          :limit => 40
    t.string    "salt",                      :limit => 40
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "remember_token"
    t.datetime  "remember_token_expires_at"
    t.string    "firstname",                 :limit => 40
    t.string    "lastname",                  :limit => 40
    t.string    "password_reset_code",       :limit => 40
    t.string    "activation_code",           :limit => 40
    t.timestamp "activated_at",                            :null => false
  end

  create_table "norusers_roles", :id => false, :force => true do |t|
    t.integer  "noruser_id", :limit => 11
    t.integer  "role_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end



#    add_column "norusers", "password_reset_code", :string, :limit => 40
#    add_column :norusers, :activation_code, :string, :limit => 40
#    add_column :norusers, :activated_at, :datetime

  end

  def self.down
 #   remove_column "norusers", "password_reset_code" 
 #   remove_column "norusers", "activation_code"
 #   remove_column "norusers", "activated_at"

  end
end
