class ChannelTwitter < ApplicationRecord
  
  belongs_to :vtuber
  
  validates :regist_type, presence: true
end
