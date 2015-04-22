# seekrit

Put your app's secrets in Redis. Then you can do whatever you want
to pull them out and shove them into environment variables or
whatever.

## Why?

You don't ever want folks getting all your app's third party access
credentials. The way most people do this is by using environment variables
that are accessible to the process itself. These are usually put into a
shell script or something like that that's referenced prior to launching
the application.

In Ruby, you might have something like...

```ruby
some_fancy_method(ENV['SUPER_DUPER_SECRET_KEY'])
```

So in this case, you'd have to put SUPER_DUPER_SECRET_KEY somewhere in the
process responsible for launching the Ruby process running. This is generally
going to be done by configuration automation software.

But where does that software *get* the super duper secret key?

## Enter seekrit.

With seekrit, you can create simple keys that hold simple values, then use
seekrit's very simplistic HTTP API to get, set and remove keys as you please.

## Status: DEVELOPMENT

Don't use this code for anything production or mission-critical yet.
It isn't quite finished, automated tests have yet to be done, and it
hasn't been used terribly much by anyone just yet, so feel free to play
with it, but don't blame me if something goes sideways!

## Setup

This is a Ruby Sinatra app. You need a valid, running Ruby environment for it.
Assuming you have [redis](http://redis.io) already installed and running
on localhost:6379:

1. Clone the code
2. Make up your own API key that will be stored in redis: ```redis-cli set seekrit_api_key "abc123"```
3. Install dependencies with Bundler: ```bundle install```
4. Run the server: ```RACK_ENV="production" bundle exec puma``` (or unicorn)

Now you have this running with redis on localhost.

# Environment Variables Used

seekrit will use the following environment variables if you supply them on
launch:

+ REDIS_HOST: default: localhost // could be any host you want running redis
+ REDIS_PORT: default: 6379 // port that redis is listening on w/ given host
+ RACK_ENV: default: "development" // Runtime environment to run in (dev/prod)

# Redis Keys Used

seekrit uses the following Redis keys:

+ seekrit_api_key: any random string; all requests must specify this string in the request headers to be served
+ development_SEEKRIT_secrits: Where "development" may actually be "staging" or "production" or whatever you set in RACK_ENV; this is the keyspace in which seekrit keeps all your keys as one big hash.

# API Overview

All responses will be JSON.

+ GET /api/all returns JSON with all keys and values.
+ GET /api/:key returns the key and value as JSON (e.g. hash)
+ POST /api/set creates a new key if you specify the params secret and value.
+ DELETE /api/:name removes a given key from the main hash, if you specify the name parameter

# PROGRAMMERS NOTE: Redo pieces of these docs to match new routes, /api/ namespace
# Redo curl examples too
# Point out tests

Examples with curl:

## Get all keys/values as JSON
```curl -v --header "X-Seekrit-Key: abc123" http://localhost:9292```

```
* Rebuilt URL to: http://localhost:9292/
* Hostname was NOT found in DNS cache
*   Trying ::1...
* connect to ::1 port 9292 failed: Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 9292 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.37.1
> Host: localhost:9292
> Accept: */*
> X-Seekrit-Key: abc123
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< X-Content-Type-Options: nosniff
< Content-Length: 42
<
{"api_key2":"abc123xyz","mykey":"someval"}
```

## Remove a specific key and its value
```curl -X DELETE -v --header "X-Seekrit-Key: abc123" http://localhost:9292/remove/mykey```

```
* Hostname was NOT found in DNS cache
*   Trying ::1...
* connect to ::1 port 9292 failed: Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 9292 (#0)
> DELETE /remove/mykey HTTP/1.1
> User-Agent: curl/7.37.1
> Host: localhost:9292
> Accept: */*
> X-Seekrit-Key: abc123
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< X-Content-Type-Options: nosniff
< Content-Length: 15
<
{"status":"OK"}
```

## Create a new key with a new value
```curl -X POST --data "secret=mail_api_key&value=foobarbaz" -v --header "X-Seekrit-Key: abc123" http://localhost:9292/new```

```
* Hostname was NOT found in DNS cache
*   Trying ::1...
* connect to ::1 port 9292 failed: Connection refused
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 9292 (#0)
> POST /new HTTP/1.1
> User-Agent: curl/7.37.1
> Host: localhost:9292
> Accept: */*
> X-Seekrit-Key: abc123
> Content-Length: 35
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 35 out of 35 bytes
< HTTP/1.1 200 OK
< Content-Type: application/json
< X-Content-Type-Options: nosniff
< Content-Length: 15
<
{"status":"OK"}
```
