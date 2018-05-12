class ChannelsController < ApplicationController
  def show
    
    begin
    
      #channelId
      channelId = params[:id]
      @vtuber = Vtuber.find_by(channelId: channelId)
      
      #チャンネル情報を更新
      @vtuber.updateChannels(channelId)
      
      #最新の動画を取得
      @movies = Movie.get_movies_snippet(channelId)
      
      # config/initializers/twitter.rbの設定を読み込む
      t_client = get_twitter_service
      
      @channel_tweets = Tweet.get_usertimeline(t_client, @vtuber.get_channel_twitters(@vtuber.channelId))
      @tag_tweets = Tweet.get_tagtweets(t_client, @vtuber.get_hashtags(@vtuber.channelId))
      
      
    rescue Google::APIClient::TransmissionError => e
      
      puts e.result.body
      
    end
    
  end

end
