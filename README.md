bung
====

Email bungholio - stupid api endpoint that will accept a set of email conversation participants and then handle their anonymisation

say what?
---------

1. send a list of email addresses

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -XPOST 'http://localhost:9292/v1/initial' -d '{"emails": ["userA@example.com", "userB@someotherexample.de", "userC@monkeypalace.eu"], "domain": "my_awesome_domain.com"}'

>> {
    "userA@example.com":"837b3c+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com",
    "userB@someotherexample.de":"c103a2+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com",
    "userC@monkeypalace.eu":"24ca58+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com"
}
```

2. notice that the response hash consists of the :to_email => :user_hash+:record_hash@
3. please note: you pass in the domain of your service that will be sending and recieving the anonymous emails which is then appended to the generated hash
4. you will then need to send out the email using whatever service you use to do that (mailchimp,sendgrid et al)
5. the recipients each get the email with the reply-to/from being the '837b3c+8f498a3049d0013240a514109fe3e051@your_awesome_domain.com' value
6. they respond (as they do)
7. your service recieves the email and then sends the recipient (:hash@my_awesome_domain.com) email address.. i.e. '837b3c+8f498a3049d0013240a514109fe3e051@your_awesome_domain.com'
8. yes, thats right its a bit weird.. I did say the recipient.. but its a reductive-boolean-union of the email address list
9. query the api like so

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -XPOST 'http://localhost:9292/v1/responded' -d '{"from": "837b3c+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com"}'

>> {
    "c103a2+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com":"userB@someotherexample.de",
    "24ca58+4b6ba9204a23013240b714109fe3e051@my_awesome_domain.com":"userC@monkeypalace.eu"
}
``` 


10. Please not: You do not have to provide the domain here, as its extracted from the from value
11. so now you know who is going to be recieving this reply.. so go ahead and send the email to them.. makeing sure that the reply-to and from are set as the specific user hash



Install
-------

1. its just a gem
2. git clone https://github.com/rosscdh/bung.git
3. bundle # to install all the stuff
4. ensure you have redis running: $redis = Redis.new(:host => 'localhost', :port => 6379)
5. foreman start puma
6. 6. hit that api

ToDo
----

1. add data field to record statistics and such
2. tests.
3. loadtest (stormforger.com)
4. send ross a note
