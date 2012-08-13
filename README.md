# EventSpitter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'event_spitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_spitter

## Usage

    # include EventSpitter in your class.
    class Something
      include EventSpitter
    end

    something = Something.new

    # Then add a listener
    listener = ->(msg) { puts('msg') }
    something.on('greeting', listener)

    # Trigger the event
    something.emit('greeting', 'hello world')
    # => "hello world"

    # Add a listener that will fire one time only
    one_timer = ->(msg) { puts(msg + ' once') }
    something.once('greeting', one_timer)

    something.emit('greeting', 'hello world')
    # => "hello world"
    # => "hello world once"

    something.emit('greeting', 'hello world')
    # => "hello world"

    # Remove a listener
    # something.off('greeting', listener)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
