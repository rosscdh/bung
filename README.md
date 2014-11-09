bung
====

Email bungholio - stupid api endpoint that will accept a set of email conversation participants and then handle their anonymisation

say what?
---------

1. send a list of email addresses

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -XPOST 'http://localhost:9292/v1/initial' -d '{"emails": ["userA@example.com", "userB@someotherexample.de", "userC@monkeypalace.eu"]}'

>> {"userA@example.com":"837b3c+8f498a3049d0013240a514109fe3e051@","userB@someotherexample.de":"c103a2+8f498a3049d0013240a514109fe3e051@","userC@monkeypalace.eu":"24ca58+8f498a3049d0013240a514109fe3e051@"}
```

2. notice that the response hash consists of the :to_email => :user_hash+:record_hash@
3. you will need to append your MX domain to the id hash. i.e. '837b3c+8f498a3049d0013240a514109fe3e051@' becomes '837b3c+8f498a3049d0013240a514109fe3e051@your_awesome_domain.com'
4. you will then need to send out the email using whatever service you use

5. the recipients each get the email with the reply-to/from being the '837b3c+8f498a3049d0013240a514109fe3e051@your_awesome_domain.com' value
6. they respond (as they do)
7. your service recieves the email and then sends the recipient email address.. i.e. '837b3c+8f498a3049d0013240a514109fe3e051@your_awesome_domain.com'
8. yes, thats right its a bit weird but its a reductive-boolean-union of the email address list
9. query the api like so

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -XPOST 'http://localhost:9292/v1/responded' -d '{"from": "837b3c+8f498a3049d0013240a514109fe3e051@domain.com"}'

>> {"c103a2+8f498a3049d0013240a514109fe3e051@":"userB@someotherexample.de","24ca58+8f498a3049d0013240a514109fe3e051@":"userC@monkeypalace.eu"}
``` 

10. and now you can forward the email message onto the other recipients


Install
-------

1. its just a gem
2. git clone https://github.com/rosscdh/bung.git
3. bundle # to install all the stuff
4. ensure you have redis running: $redis = Redis.new(:host => 'localhost', :port => 6379)


ToDo
----

1. add data field to record statistics and such
2. tests.
3. loadtest (stormforger.com)
4. send ross a note