class RegistrationsController < ApplicationController
  def index
    
    @vtubers = Vtuber.all
    
  end

  def new
    
    @vtuber = Vtuber.new
    
  end
  
  def create
    
    @vtuber = Vtuber.new(vtuber_params)
    @vtuber.save
    
    #snippet
    snippet = @vtuber.get_channel_snippet(@vtuber.channelId)
    @vtuber.update_attributes(channelTitle: snippet.title, thumbnail: snippet.thumbnails.medium.url, description: snippet.description, publishedAt: snippet.publishedAt)
    
    #statistics
    statistics = @vtuber.get_channel_statistics(@vtuber.channelId)
    @vtuber.create_channel_statistic(viewCount: statistics.viewCount, subscriberCount: statistics.subscriberCount, videoCount: statistics.videoCount)
    
    redirect_to registrations_path
    
  end

  def destroy
  end
  
  private
  
  def vtuber_params
    params.require(:vtuber).permit(:name, :channelId)
  end
  
  
end
