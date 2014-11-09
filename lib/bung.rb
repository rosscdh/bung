require 'grape'
require './lib/services'

module Bung
  class API < Grape::API
    version 'v1', using: :path
    format :json

    resource :initial do
      desc "Send List of email addresses and get reply-to values for each."
      params do
        requires :emails, type: Array, desc: "List of participating email addresses ['hello@example.com', 'recipient@example.com']"
      end

      post "/" do
        service = Bung::RecieveEmailService.new params[:emails]
        service.process
      end
    end

    resource :responded do
      desc "Pass the 'from' email address which was the reply-to that a participant responds to"
      params do
        requires :from, type: String, desc: "The email to email address, should be in form 'af68de+1af10ca049cb0132409414109fe3e051@domain.com' i.e. :identifier+:hash@domain.com"
      end
      post "/" do
        service = Bung::EmailResponseService.new params[:from]
        service.process
      end

    end


    get "/" do
      {"message" => "Post in some data to /v1/bungs/create/ POST {\"emails\": [\"userA@example.com\", \"userB@example.com\"]}"}
    end

  end
end