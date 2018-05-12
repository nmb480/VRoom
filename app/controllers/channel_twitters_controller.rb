class ChannelTwittersController < ApplicationController
  def new
    
    id = params[:id]
    @channel = Vtuber.find_by(channelId: id)
    
    @twitters = []
    @hashtags = []
    @channel.channel_twitters.each do |channel_twitter|
      if channel_twitter.regist_type == 'screen_name'
        @twitters << channel_twitter
      else
        @hashtags << channel_twitter
      end
    end
    
    @channel_twitter  = @channel.channel_twitters.build
    @channel_twitters = @channel.channel_twitters.all
    
    
    
  end

  def create
    
    channel = Vtuber.find_by(channelid: params[:channel_twitter][:channelid])
    @channel_twitter = channel.channel_twitters.build(twitter_params)
    
    @channel_twitter.save
    
    redirect_to new_channel_twitter_path(id:channel.channelId)
    
  end
  
  def destroy
    channelId = params[:vtuber_id]
    id       = params[:id]
    channel = Vtuber.find(channelId)
    twitter = channel.channel_twitters.find(id)
    twitter.destroy
    redirect_to new_channel_twitter_path(id: channel.channelId)
  
  end
  
  private
  
  def twitter_params
    params.require(:channel_twitter).permit(:screen_name, :hashtag, :regist_type)
  end
end
