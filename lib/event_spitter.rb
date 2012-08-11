require "event_spitter/version"

module EventSpitter

  def on(event_name, handler)
    events[event_name] = Array(events[event_name]) << handler
  end
  alias_method :add_listener, :on

  def off(event_name, handler)
    Array(events[event_name]).delete(handler)
  end
  alias_method :remove_listener, :off

  def once(event_name, handler)
    new_handler = ->(*args) do
      handler.call(*args)
      off(event_name, new_handler)
    end

    on(event_name, new_handler)
  end

  def listeners(event_name)
    events[event_name]
  end

  def emit(event_name, *args)
    events.fetch(event_name, []).each do |handler|
      handler.call(*args)
    end
  end

  def remove_all_listeners(*event_names)
    if event_names.any?
      event_names.each { |key| events.delete(key) }
    else
      events.clear
    end
  end

  def events
    @events ||= {}
  end
end
