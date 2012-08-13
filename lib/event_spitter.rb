require "event_spitter/version"

module EventSpitter

  # Public: Add a listener for an event.
  #
  # event_name - The String name of the event.
  # listener    - The Proc listener for the event.
  #
  # Examples
  #
  #   listener = ->(msg) { puts(msg) }
  #   emitter.on('connection', listener)
  #
  # Returns nothing.
  def on(event_name, listener)
    events[event_name] = Array(events[event_name]) << listener
  end
  alias_method :add_listener, :on

  # Public: Remove a listener for an event.
  #
  # event_name - The String name of the event.
  # listener    - The Proc listener on the event.
  #
  # Examples
  #
  #   emitter.off('connection', listener)
  #
  # Returns nothing.
  def off(event_name, listener)
    Array(events[event_name]).delete(listener)
  end
  alias_method :remove_listener, :off

  # Public: Adds a one time listener for the event.
  #
  # event_name - The String name of the event.
  # listener    - The Proc listener for the event.
  #
  # Examples
  #
  #   listener = ->(msg) { puts(msg) }
  #   emitter.once('connection', listener)
  #
  # Returns nothing.
  def once(event_name, listener)
    new_listener = ->(*args) do
      listener.call(*args)
      off(event_name, new_listener)
    end

    on(event_name, new_listener)
  end

  # Public: An Array of listeners for an event.
  #
  # Returns event listeners Array.
  def listeners(event_name)
    events[event_name]
  end

  # Public: Executes the listeners for an event.
  #
  # event_name - The String event name.
  # args       - Zero or more argument to be passed to the listeners.
  #
  # Examples
  #
  #   emitter.emit('connection', 'hello world!')
  #
  # Returns nothing.
  def emit(event_name, *args)
    events.fetch(event_name, []).each do |listener|
      listener.call(*args)
    end
  end

  # Public: Remove all listeners for event names. If zero event names
  # as supplied then all event listeners are removed.
  #
  # event_names - Zero or more String event names.
  #
  # Examples
  #
  #   emitter.remove_all_listeners
  #
  #   emitter.remove_all_listeners('connection')
  #
  # Returns nothing.
  def remove_all_listeners(*event_names)
    if event_names.any?
      event_names.each { |key| events.delete(key) }
    else
      events.clear
    end
  end

  # Internal: The list of events.
  #
  # Returns a Hash of events and their listeners.
  def events
    @events ||= {}
  end
end
