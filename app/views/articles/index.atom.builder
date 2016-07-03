  atom_feed(:url => formatted_article_url(:atom)) do |feed|
    feed.title("Address book")
    feed.updated(@people.first ? @people.first.created_at : Time.now.utc)
  
    for post in @posts
      feed.entry(post) do |entry|
        entry.title(post.title)
        entry.content(post.body, :type => 'html')

        entry.author do |author|
          author.name(post.creator.name)
          author.email(post.creator.email_address)
        end
      end
    end
  end

