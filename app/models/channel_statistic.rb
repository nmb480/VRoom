class ChannelStatistic < ApplicationRecord
  belongs_to :vtuber
  
  def self.updateChannelStitistics
    
    # config/initializers/youtube.rbの設定を読み込む
    client, youtube = get_service
    
    Vtuber.all.each do |vtuber|
      
      channelId = vtuber['channelId']
      
      # 検索開始
      result = client.execute!(
          :api_method => youtube.channels.list,
          :parameters => {
            :part => 'statistics',
            :id   => channelId
          }
      )
      
      statistics = result.data.items.first.statistics
      
      viewCount       = statistics['viewCount']
      subscriberCount = statistics['subscriberCount']
      videoCount      = statistics['videoCount']
      
      @statistics = vtuber.channel_statistic.update_attributes(viewCount: viewCount, subscriberCount: subscriberCount, videoCount: videoCount)
    end
    
  end
  
  
end
