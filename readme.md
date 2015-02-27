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
your configuration automation tools to access redis directly, then
put those keys and values into the correct files on your operating system
of choice.

## Status: EARLY DEVELOPMENT

There is absolutely no reason on this Earth you should be using this code
right now.

Just. Don't.

It's still in the concept phase and definitely not at all production ready.
It's just some dude screwing around with it right now, and that's not prod
ready, yo. So don't.

## Security Notes and Advice

1. Run this on one machine and one machine only that's not accessible to the
world at large, but only to your IP address (or a block of them, or on your
VPN or whatever).
2. You use this app to manage the keys and values. Then you can use redis-cli
to fetch the keys and values with your configuration automation. (Note: If the
community wants it and it sounds like a good idea, we might implement a simple
HTTP API with support for GET only in the future. You still need to guard the
app on the network level though).
3. If you can reach the app from the global internet without whitelisting
your IP, you're open to attack.
4. Final security model is TBD but generally we'll store a crypted/salted
password for a single admin user in redis itself, and compare against that upon
login. Or possibly on each request. If API and such.
