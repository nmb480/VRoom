class Vtuber < ApplicationRecord
  #validation
  validates :channelId, presence: true

  has_many :channel_twitters
  has_many :lives, class_name: 'Live'
  has_many :movies
  
  has_one :channel_statistic
  
  def self.updateAllChannels
    
    Vtuber.all.each do |vtuber|
      
      vtuber.updateChannels(vtuber.channelId)
      
    end
    
  end
  
  def updateChannels(channelId)
    
    @vtuber = Vtuber.find_by(channelId: channelId)
    
    #snippet
    snippet = @vtuber.get_channel_snippet(channelId)
    @vtuber.update_attributes(channelTitle: snippet.title, thumbnail: snippet.thumbnails.medium.url, description: snippet.description, publishedAt: snippet.publishedAt)
    
    #statistics
    statistics = @vtuber.get_channel_statistics(channelId)
    @vtuber.channel_statistic.update_attributes(viewCount: statistics.viewCount, subscriberCount: statistics.subscriberCount, videoCount: statistics.videoCount)
    
  end
  
  #================================================== snippet
  #============================================================
  def get_channel_snippet(channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    # 検索開始
    results = client.execute!(
        :api_method => youtube.channels.list,
        :parameters => {
          :part => 'snippet',
          :id   => channelId
        }
    )
    
    return results.data.items.first.snippet
    
  end
  
  #================================================== statistics
  #============================================================
  
  def get_channel_statistics(channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    # 検索開始
    statistics = client.execute!(
        :api_method => youtube.channels.list,
        :parameters => {
          
          :part => 'statistics',
          :id   => channelId
        }
    )
    
    return statistics.data.items.first.statistics
    
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
  
  def get_channel_twitters(channelId)
    
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
  
  def get_hashtags(id)
    
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
