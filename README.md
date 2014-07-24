# Beluga

Tiny (< 150 LOC) ruby modular irc bot framework that depends on nothing but the ruby standard library.

The ruby take on [Emily/PyBeluga](https://github.com/Emily/PyBeluga)

Beluga is at 128 LOC as of the last update of this README

## Base Features

1. Basic IRC Connection (Ping/Pong/etc...)
2. Plugin Management (load, unload, reload, etc...)
3. Sending IRC "events" to aforementioned plugins

## Installation

Add this line to your application's Gemfile:

    gem 'beluga'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beluga

## Usage

    b = Beluga.new(config_hash)
    b.connect!

You can alter and reload the handler class while a Beluga instance is running. To reload the handler class, simply send "reload handler" in a room the bot is connected to. You can change this command in handler itself.

## Contributing

1. Fork it ( https://github.com/Emily/Beluga/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
