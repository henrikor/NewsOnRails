#  lags = @articles
#  atom_feed(:url => formatted_lag_index_url(:atom)) do |feed|
#    feed.title("Test")
#    feed.updated(lags.first ? lags.first.created_on : Time.now.utc)
#
#    for lag in lags
#      feed.entry(lag) do |entry|
#        entry.title(lag.title)
#        entry.content(lag.body, :type => 'html')
#
#        entry.author do |author|
#          author.name(lag.creator.name)
#          author.email(lag.creator.email_address)
#        end
#      end
#      end
#    end
 

###




# index.rss.builder
xml.instruct! :xml, :version => "1.0", :encoding=>"iso-8859-1"
xml.rss :version => "2.0",
            'xmlns:content' => "http://purl.org/rss/1.0/modules/content/",
            'xmlns:wfw' => "http://wellformedweb.org/CommentAPI/",
            'xmlns:dc' => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title @organization + " : " + @groupname
    xml.description "Artikler fra " + @organization
    xml.link "http://#{@domene}"

    for article in @articles
      article.ingress = article.ingress.gsub(/\[\[.*\]\]/, '')
      xml.item do
        xml.title article.headline
        xml.description article.ingress
        xml.tag!("content:encoded") do
          xml.cdata!(text2html(article.story_text, article.cloth))
        end

        xml.pubDate article.created_on.to_s(:rfc822)
        xml.link formatted_start_url(article, :html)

        #        xml.guid formatted_lag_index_url(article)
        #        xml.link formatted_lag_index_url(article, :rss)
        #        xml.guid formatted_lag_index_url(article, :rss)
      end
    end
  end
end

#xml.item :foo => 'bar' do
#  xml.title "My Article"
#  xml.description "DETTE er en test"
#end
