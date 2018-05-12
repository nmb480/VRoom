class ToppagesController < ApplicationController
  
  def index
    
    begin
      
      #最新の動画
      @movies = Movie.limit(20).order(publishedAt: :desc)
      
      #生配信を検索
      @lives = Live.all
      
      
    rescue Google::APIClient::TransmissionError => e
      
      puts e.result.body
      
    end
      
  end
  
  private
  
  def read(video)
    url = video['id']['videoId']
    title = video['snippet']['title']
    img = video['snippet']['thumbnails']['medium']['url']
    channel_url = video['snippet']['channelId']
    channel_title = video['snippet']['channelTitle']
    
    return {
      url: "https://www.youtube.com/watch?v=#{url}",
      title: title,
      img: img,
      channel_title: channel_title,
      channel_url: channel_url
    }
  end
  
  def get_uploads()
    
  end
    
end
