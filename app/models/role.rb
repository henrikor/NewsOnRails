# -*- encoding : utf-8 -*-
class Role < ActiveRecord::Base
  has_and_belongs_to_many :norusers
  has_many :group_roles
  belongs_to :authorizable, :polymorphic => true
  acts_as_authorizable

end
