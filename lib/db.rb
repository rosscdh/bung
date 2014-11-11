require 'redis'
require 'redis_orm'
require 'digest/sha1'

$redis = Redis.new(:host => ENV.fetch('REDIS_HOST', 'localhost'), :port => ENV.fetch('REDIS_PORT', 6379))


class BungModel < RedisOrm::Base
  use_uuid_as_id

  property :emails, Array

  timestamps

  index :id

  def all_reply_tos
    reply_to = {}
    emails.each do |email|
      reply_to[email] = reply_to_user_hash( email )
    end
    reply_to
  end

  def reply_tos_excluding( user_id )
    reply_to = {}
    emails.each do |email|
      if user_hash( email ) != user_id
        reply_to[email] = reply_to_user_hash( email )
      end
    end
    reply_to
  end

  def sender( user_id )
    resp = {}
    sender_email = nil
    emails.each do |email|
      if user_hash( email ) == user_id
        sender_email = email
        break
      end
    end
    resp[sender_email] = reply_to_user_hash( sender_email )
    resp
  end

  def reply_to_user_hash( email )
    user_hash( email ) +'+'+ id
  end

  def user_hash( email )
    Digest::SHA1.hexdigest( email )[0..5]
  end

end