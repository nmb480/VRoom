class Movie < ApplicationRecord
  
  validates :videoId, presence: true
  validates :title, presence: true
  validates :thumbnail, presence: true
  validates :publishedAt, presence: true
  
  belongs_to :vtuber
  
  attr_accessor :viewCount, :likeCount, :commentCount
  
  def self.getAllMovies
    
    @movies = []
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    #DBに登録されているvtuber全員分の生放送を検索する。
    Vtuber.all.each do |vtuber|
      
      #search.listから生配信を検索
      results = client.execute!(
          :api_method => youtube.search.list,
          :parameters => {
            :part          => 'snippet',
            :channelId     => vtuber['channelId'],
            :maxResults    => 3,
            :type          => 'video',
            :order         => 'date'
          }
      )
      
      results.data.items.each do |result|
        video = Movie.snippet_read(result)
        begin
          @movie = vtuber.movies.create(videoId: video[:videoId], title: video[:title], thumbnail: video[:thumbnail], publishedAt: video[:publishedAt])
        rescue
         next
        end
       
        @movies << @movie
      end
      
    end
    
    return @movies
    
  end
  
  def self.get_movies_snippet(channelId)
    
    vtuber = Vtuber.find_by(channelId: channelId)
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
      
    #search.listから生配信を検索
    results = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          :part          => 'snippet',
          :channelId     => channelId,
          :type          => 'video',
          :order         => 'date'
        }
    )
    
    #結果を配列に格納
    movies = []
    results.data.items.each do |result|
      movie = vtuber.movies.build(Movie.snippet_read(result))
      movies << movie
    end
    
    return movies
    
  end
  
  def get_movies_statistics
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    #search.listから生配信を検索
    result = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part   => 'statistics',
        :id     => @videoId,
      }
    )
    
    statistics = result.data.items.first
    
    return statistics_read(statistics)
    
  end
  
  def self.snippet_read(video)
    videoId     = video['id']['videoId']
    title       = video['snippet']['title']
    thumbnail   = video['snippet']['thumbnails']['medium']['url']
    publishedAt = video['snippet']['publishedAt']
    
    return {
      videoId: videoId,
      title: title,
      thumbnail: thumbnail,
      publishedAt: publishedAt
    }
  end
  
  def self.statistics_read(video)
    viewCount    = video['statistics']['viewCount']
    likeCount    = video['statistics']['likeCount']
    commentCount = video['statistics']['commentCount']
    
    return {
      viewCount: viewCount,
      likeCount: likeCount,
      commentCount: commentCount,
    }
  end
  
end