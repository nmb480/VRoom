class Live < ApplicationRecord
  validates :liveId, presence: true
  validates :title, presence: true
  validates :thumbnail, presence: true
  
  belongs_to :vtuber
  
  def self.getAllLives
    #一旦tableの中身を全部消す
    Live.delete_all()
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    #DBに登録されているvtuber全員分の生放送を検索する。
    vtubers = Vtuber.all
    vtubers.each do |vtuber|
      
      #search.listから生配信を検索
      live_result = client.execute!(
          :api_method => youtube.search.list,
          :parameters => {
            :part          => 'snippet',
            :channelId     => vtuber['channelId'],
            :eventType     => 'live',
            :regionCode    => 'JP',
            :type          => 'video'
            
          }
      )
      
      #帰ってきた結果に対して、空白でなければ配列に格納する
      result = live_result.data.items.first
      unless result.blank?
        @live = vtuber.lives.build(Live.read(result))
        @live.save
      end
      
      
    end
    
  end
  
  def self.read(result)
    liveid       = result['id']['videoId']
    title        = result['snippet']['title']
    thumbnail    = result['snippet']['thumbnails']['medium']['url']
    
    return {
      liveId: liveid,
      title: title,
      thumbnail: thumbnail,
    }
  end
end