require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/event_spitter'

class DummyClass; include EventSpitter; end

class EventSpitterTest < MiniTest::Unit::TestCase

  def test_adding_an_event_listener
    obj = DummyClass.new
    listener = ->() {}
    obj.on('something-cool', listener)

    assert_equal [listener], obj.listeners('something-cool')
  end

  def test_removing_an_event_listener
    obj = DummyClass.new
    listener = ->() {}
    obj.on('something-cool', listener)

    obj.off('something-cool', listener)
    assert_empty obj.listeners('something-cool')
  end

  def test_emitting_an_event
    obj = DummyClass.new
    listener = MiniTest::Mock.new
    listener.expect(:call, 42)

    obj.on('something-cool', listener)
    obj.emit('something-cool')
    listener.verify
  end

  def test_emitting_an_event_passing_args
    obj = DummyClass.new
    listener = MiniTest::Mock.new
    listener.expect(:call, 42, ['rock-on'])

    obj.on('something-cool', listener)
    obj.emit('something-cool', 'rock-on')
    listener.verify
  end

  def test_remove_all_listeners_with_arguments
    obj = DummyClass.new
    listener = ->() {}

    obj.on('something-cool', listener)
    obj.on('whats-that', listener)

    obj.remove_all_listeners('something-cool', 'whats-that')

    assert_nil obj.listeners('something-cool'), '"something-cool" event listeners not removed'
    assert_nil obj.listeners('whats-that'), '"whats-that" event listeners not removed'
  end

  def test_remove_all_listeners_without_arguments
    obj = DummyClass.new
    listener = ->() {}

    obj.on('something-cool', listener)
    obj.on('whats-that', listener)

    obj.remove_all_listeners

    assert_nil obj.listeners('something-cool'), '"something-cool" event listeners not removed'
    assert_nil obj.listeners('whats-that'), '"whats-that" event listeners not removed'
  end

  def test_adding_one_time_listener
    obj = DummyClass.new
    listener = ->() { }

    obj.once('something-cool', listener)
    obj.emit('something-cool')

    assert_empty obj.listeners('something-cool')
  end

  def test_one_time_listener_does_not_stomp_args
    obj = DummyClass.new
    listener = MiniTest::Mock.new
    listener.expect(:call, 42, ['rock-on'])

    obj.once('something-cool', listener)
    obj.emit('something-cool', 'rock-on')
    listener.verify
  end
end