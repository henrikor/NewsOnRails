# -*- encoding : utf-8 -*-
class Stylesheet < ActiveRecord::Base
  has_and_belongs_to_many :groups
  before_destroy :dont_destroy_meta

  def self.css_fil_save(cssid, csstxt)
#    fil = File.open("#{Rails.root}/public/stylesheets/#{cssid}.css", "w+")
    fil = File.open("#{Rails.root}/app/assets/stylesheets/#{cssid}.css", "w+")
    fil.syswrite(csstxt)
  end
  
  private
  def dont_destroy_meta
    systemgroups = [1, 2, 3]
    raise "Can't destroy system stylesheet: #{self.name}!" if systemgroups.include?(self.id)
  end

end
