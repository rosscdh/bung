require 'digest/sha1'
require 'encrypto_signo'

private_key = File.read("./keys/private.key")
public_key  = File.read("./keys/public.key")

#require './lib/db'
#
# email_hash = {"from" => "sendrossemail@gmail.com", "to" => "ross@lawpal.com"}
# private_key = File.read("./keys/private.key")
# public_key  = File.read("./keys/public.key")
# encrypted_string = EncryptoSigno.encrypt(public_key, email_hash.to_s)
#

module Bung
    #
    # Encode a provided from and to email
    # return a signed email address
    #
    class EncodeEmailService
        def initialize( from, to, body )
            @from = from
            @to = to
            @body = body
            @email = encoded_email from, to
        end

        attr_reader :email, :from, :to

        def encoded_email( from, to )
            domain = 'lawpal.com'
            username = ''
            "#{username}@#{domain}"
        end

    end

    #
    # Decode the :hashed_from_and_to_email@:domain.com
    #
    class DecodeEmailService
        def initialize( email )
            @email = email
        end

        attr_reader :email, :from, :to

        def process
        end

    end

    #
    # Email Processing and Key setup Service
    # Handle the recieved email
    # and get its db key for recording
    #
    class RecieveEmailService
        def initialize(from, to, body)
            @from = from
            @to = to
            @body = body
            @key = self.key_hash

            send_email_service = Bung::SendEmailService.new @from, @to, @body

            if not send_email_service.process
                record_email_service = Bung::RecordEmailService.new @key, @from, @to, @body
                record_email_service.process
            else
                # throw error
                # log it?
            end
        end

        attr_reader :key

        private

        #
        # return the SHA1 hash of the ordered from and to email addresses
        # this hash is then the primary key of the record for this correspondence
        #
        def key_hash
            Digest::SHA1.hexdigest [
                                    user_domain_val( @from ),
                                    user_domain_val( @to )
                                   ].sort { |a, b| b[1]<=>a[1]}.to_s
        end

        def user_domain_val( email )
            email_split = email.split("@")  # username
            username_domain = email_split[0].concat(email_split[1].split(".")[0])  # fqn domain
            username_domain_num = username_domain.each_char.map{ |x| x.ord }  # get ordinals
            num_sum = username_domain_num.inject{ |sum, x| sum + x }  # sum ordinals
            {num_sum => email}
        end
    end

    #
    # Email Sender Service
    # used to send the email
    #
    class SendEmailService
        def initialize(from, to, body)
            @from = from
            @to = to
            @body = body
        end
        def process
        end
    end

    #
    # Email Recorder Service
    # used to record the sent email
    #
    class RecordEmailService
        def initialize(key, from, to, body)
            @key = key
            @from = from
            @to = to
            @body = body
        end
        def process
        end
    end
end
