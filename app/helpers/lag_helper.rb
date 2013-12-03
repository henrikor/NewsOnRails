# -*- encoding : utf-8 -*-
module LagHelper
def text2a_name(text)
    text = text.gsub(/\s/, '_')
    text = norsk2html(text, "r")
  end

end
