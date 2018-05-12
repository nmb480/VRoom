class Channel
  
  include ActiveModel::Model
  
  attr_accessor :id, :title, :description, :thumbnails, :subscribercount, :videocount, :name, :channel_twitters, :hashtags
  
  def self.getChannelPage(channelId)
    
    #必要情報を取得
    info       = Channel.get_channel_info(channelId)
    statistics = Channel.get_channel_statistics(channelId)
    
    # snippet
    description = info.snippet.description
    
    # statistics
    subscribercount = statistics.statistics.subscriberCount
    videocount      = statistics.statistics.videoCount
    
    #twitter
    channel_twitters = Channel.get_channel_twitter(channelId)
    hashtags         = Channel.get_hashtag(channelId)
    
    return {
      description: description,
      subscribercount: subscribercount,
      videocount: videocount,
      channel_twitters: channel_twitters,
      hashtags: hashtags
      }
  end
  
  #================================================== snippet
  #============================================================
  def self.get_channel_info(channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    # 検索開始
    channel_info = client.execute!(
        :api_method => youtube.channels.list,
        :parameters => {
          
          :part => 'snippet',
          :id   => channelId
        }
    )
    
    return channel_info.data.items.first
    
  end
  
  #================================================== statistics
  #============================================================
  def self.get_channel_statistics(channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    # 検索開始
    channel_statistics = client.execute!(
        :api_method => youtube.channels.list,
        :parameters => {
          
          :part => 'statistics',
          :id   => channelId
        }
    )
    
    return channel_statistics.data.items.first
    
  end
  
  #================================================== video
  #============================================================
  def self.get_uploads(channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    #空の配列準備
    movies = []
    
    videos = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          
          :part      => 'snippet',
          :channelId => channelId,
          :order     => 'date'
        }
    )
    
    videos.data.items.each do |video|
      movie = Movie.new()
      movie_info = movie.read(video)
      movies << movie_info
    end
    
    return movies
    
  end
  
  #================================================== channel_twitter
  #============================================================
  
  def self.get_channel_twitter(channelId)
    
    channel_twitter = []
    channel = Vtuber.find_by(channelid: channelId)
    
    channel.channel_twitters.each do |twitter|
      if twitter.regist_type == 'screen_name'
          channel_twitter << twitter.screen_name
      end
    end
    
    return channel_twitter
  
  end
  

  #================================================== hashtag
  #============================================================
  
  def self.get_hashtag(id)
    
    hashtag = []
    channel = Vtuber.find_by(channelid: id)
    
    channel.channel_twitters.each do |twitter|
      if twitter.regist_type == 'hashtag'
          hashtag << twitter.hashtag
      end
    end
    
    return hashtag
  
  end
  
end