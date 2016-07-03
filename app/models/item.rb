# -*- encoding : utf-8 -*-
class Item
  attr_reader :body
  DB = []

  def initialize( body ) 
    @body=body 
  end
  def add()
    if (@body == "empty")
      return "No group"
    else
      DB.delete_if { |x| (@body == x.body) || (@body == "#{x.body}") }
      DB.unshift(self)
      DB.compact!
      return "Adding group: @body ..."
    end
  end
  def self.find_recent
    DB 
  end
  def del 
    DB.delete_if { |x| (@body == x.body) || (@body == "#{x.body}") }
    return "Deleting group @body ..."
  end
  def destroy
    DB.clear
  end
end

