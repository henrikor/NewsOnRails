  lags = @articles
  atom_feed(:url => formatted_lag_index_url(:atom)) do |feed|
    feed.title("Test")
    feed.updated(lags.first ? lags.first.created_on : Time.now.utc)
  
    for lag in lags
      feed.entry(lag) do |entry|
        entry.title(lag.title)
        entry.content(lag.body, :type => 'html')

        entry.author do |author|
          author.name(lag.creator.name)
          author.email(lag.creator.email_address)
        end
      end
      end
    end
 

