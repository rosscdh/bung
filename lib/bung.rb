require 'grape'
require 'debugger'
require './lib/services'
require './lib/entities'

module Bung
  class API < Grape::API
    @domain = nil
    version 'v1', using: :path
    format :json

    resource :initial do
      desc "Send List of email addresses and get reply-to values for each."
      params do
        requires :emails, type: Array, desc: "List of participating email addresses ['hello@example.com', 'recipient@example.com']"
        requires :domain, type: String, desc: "The domain that you will be using to anonymise the recipient emails. Usually your own MX service domain"
      end

      post "/" do
        status 201
        service = Bung::RecieveEmailService.new params[:emails]
        Bung::API.append_domain service.process, params[:domain]
      end
    end

    resource :responded do
      desc "Pass the 'from' email address which was the reply-to that a participant responds to"
      params do
        requires :from, type: String, desc: "The email to email address, should be in form 'af68de+1af10ca049cb0132409414109fe3e051@domain.com' i.e. :identifier+:hash@domain.com"
      end
      post "/" do
        status 202
        @domain = params[:from].split('@')[1]
        service = Bung::EmailResponseService.new params[:from]
        Bung::API.append_domain service.process, @domain
        #expose Bung::API.append_domain service.process, @domain, using: API::ReplyTo, as: :replyto
      end

    end

    def self.append_domain( user_hash, domain )
      new_user_hash = {}
      user_hash.each do |key, val|
        new_user_hash[key] = "#{val}@#{domain}"
      end
      new_user_hash
    end

    get "/" do
      {"message" => "Post in some data to /v1/bungs/create/ POST {\"emails\": [\"userA@example.com\", \"userB@example.com\"]}"}
    end

  end
end