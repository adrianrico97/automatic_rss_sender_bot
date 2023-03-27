require 'active_record'

class PostedNew < ActiveRecord::Base

  ############################################################
  # VALIDATIONS
  ############################################################
  validates_presence_of :title, :link, :posted_at, :channel_identifier

end
