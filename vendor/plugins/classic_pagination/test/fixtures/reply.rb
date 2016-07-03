# -*- encoding : utf-8 -*-
class Reply < ActiveRecord::Base
  belongs_to :topic, :include => [:replies]
  
  validates_presence_of :content
end
