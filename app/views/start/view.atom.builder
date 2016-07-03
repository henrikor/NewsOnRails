atom_feed(:url => formatted_people_url(:atom)) do |feed|
  feed.title("Address book")
  feed.updated(@article.created_on.strftime("%d.%m.%Y") ? @people.first.created_at : Time.now.utc)

  entry.content(@article.ingress, :type => 'html')
#
#  if @article.story_text =~ /\w/ && @visstory_text != 1 
#
#    if @visingress != 1
#
#      if @visheadline != 1
#        text2html("<h1>#{@article.headline}</h1>", @article.cloth, "view")
#      end
#
#      text2html(@article.ingress, @article.cloth, "view")
#      end
#
#    text2html(@article.story_text, @article.cloth, "view")
#  end
#
#  if @article.source && @vissource != 1
#    @article.source
#  end

end
