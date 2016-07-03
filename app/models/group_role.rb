# -*- encoding : utf-8 -*-
class GroupRole < ActiveRecord::Base
  belongs_to :group
  belongs_to :role
  validates_uniqueness_of :role_id, :scope => "group_id"
end
