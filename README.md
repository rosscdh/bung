bung
====

Email bungholio - stupid api endpoint that will accept a set of email conversation participants and then handle their anonymisation

say what?
---------

1. send a list of email addresses

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -XPOST 'http://localhost:9292/v1/initial' -d '{"emails": ["ross@nowhere.com","bob@example.com", "jack@yahoo.com"], "domain": "my_awesome_domain.com"}'

>> {
    "ross@nowhere.com":"d3ebb0+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com",
    "bob@example.com":"a460e3+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com",
    "jack@yahoo.com":"928025+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com"}
```

2. query the endpoint with the reply-to email that is being recieved; this will provide you with the recipient emails to forward the message on to as well as the sender info

```
curl -H "Accept: application/json" -H "Content-Type: application/json" -POST 'http://localhost:9292/v1/responded' -d '{"from": "a460e3+920093104b50013240cd14109fe3e051@my_awesome_domain.com"}'

>> {"recipients":
        {
          "ross@nowhere.com":"d3ebb0+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com",
          "bob@example.com":"a460e3+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com"
        },
    "sender": {"jack@yahoo.com":"928025+cdb33b004b50013240cd14109fe3e051@my_awesome_domain.com"}
  }
```



Apache Bench
=====

save the query for a responded request in test.json and run

```
ab -n 10000 -c 5 -H "Accept: application/json" -T "application/json" -p test.json http://localhost:9292/v1/responded

Server Software:
Server Hostname:        localhost
Server Port:            9292

Document Path:          /v1/responded
Document Length:        181 bytes

Concurrency Level:      5
Time taken for tests:   21.266 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      2780000 bytes
Total POSTed:           2330000
HTML transferred:       1810000 bytes
Requests per second:    470.24 [#/sec] (mean)
Time per request:       10.633 [ms] (mean)
Time per request:       2.127 [ms] (mean, across all concurrent requests)
Transfer rate:          127.66 [Kbytes/sec] received
                        107.00 kb/s sent
                        234.66 kb/s total

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     3   10   8.2      9     159
Waiting:        3   10   6.5      8     143
Total:          3   11   8.2      9     159

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%     10
  80%     10
  90%     11
  95%     30
  98%     33
  99%     34
 100%    159 (longest request)
```

Install
-------

1. its just a gem
2. git clone https://github.com/rosscdh/bung.git
3. bundle # to install all the stuff
4. ensure you have redis running: $redis = Redis.new(:host => 'localhost', :port => 6379)
5. foreman start web
6. 6. hit that api

ToDo
----

1. add data field to record statistics and such
2. sidekik job to save data to actual database using the uuid as a lookup index
3. in case of not found double check with database using same indexed uuid
4. tests.
5. loadtest (stormforger.com)
6. send ross a note
