
class Twitter

  def self.load_tweets
    begin
      load_tweets_cloudant
    rescue => e
      STDERR.puts "Twitter ERROR: #{e}"
      File.open('db/Bruce_tweets.txt', 'r').read  # load tweets from file
    end
  end
  
  private

  def self.load_tweets_cloudant
    server = CouchRest.new ENV['CLOUDANT_URL']
    db     = server.database!('wpi_tweets') # create db if it doesn't already exist

    # Fetch all docs
    docs   = db.all_docs include_docs: true

    tweets = ''
    docs['rows'].each do |doc|
      tweets += doc['doc']['TWEET_TEXT'] + "\n"
    end
    tweets
  end
  
end