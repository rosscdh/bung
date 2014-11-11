require './lib/db'

module Bung
  #
  # Email Processing and Key setup Service
  # Handle the recieved email
  # and get its db key for recording
  #
  class RecieveEmailService
    def initialize( emails = [] )
      @emails = emails
    end

    def process
      bung = BungModel.create :emails => @emails
      bung.all_reply_tos
    end
  end

  #
  # Email Recorder Service
  # used to record the sent email
  #
  class EmailResponseService
    def initialize( from )
      @user_id, @bung_id = from.split('@')[0].split('+')
      @bung = BungModel.find_by_id @bung_id
    end

    def process
      {
        "recipients" => @bung.reply_tos_excluding( @user_id ),
        "sender" => @bung.sender( @user_id )
      }
    end
  end
end
