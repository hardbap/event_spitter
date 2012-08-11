require 'minitest/autorun'
require 'minitest/pride'

require_relative '../event_spitter'

class DummyClass; include EventSpitter; end

class EventSpitterTest < MiniTest::Unit::TestCase

  def test_adding_an_event_listener
    obj = DummyClass.new
    handler = ->() {}
    obj.on('something-cool', handler)

    assert_equal [handler], obj.listeners('something-cool')
  end

  def test_removing_an_event_listener
    obj = DummyClass.new
    handler = ->() {}
    obj.on('something-cool', handler)

    obj.off('something-cool', handler)
    assert_empty obj.listeners('something-cool')
  end

  def test_emitting_an_event
    obj = DummyClass.new
    handler = MiniTest::Mock.new
    handler.expect(:call, 42)

    obj.on('something-cool', handler)
    obj.emit('something-cool')
    handler.verify
  end

  def test_emitting_an_event_passing_args
    obj = DummyClass.new
    handler = MiniTest::Mock.new
    handler.expect(:call, 42, ['rock-on'])

    obj.on('something-cool', handler)
    obj.emit('something-cool', 'rock-on')
    handler.verify
  end

  def test_remove_all_listeners_with_arguments
    obj = DummyClass.new
    handler = ->() {}

    obj.on('something-cool', handler)
    obj.on('whats-that', handler)

    obj.remove_all_listeners('something-cool', 'whats-that')

    assert_nil obj.listeners('something-cool'), '"something-cool" event handlers not removed'
    assert_nil obj.listeners('whats-that'), '"whats-that" event handlers not removed'
  end

  def test_remove_all_listeners_without_arguments
    obj = DummyClass.new
    handler = ->() {}

    obj.on('something-cool', handler)
    obj.on('whats-that', handler)

    obj.remove_all_listeners

    assert_nil obj.listeners('something-cool'), '"something-cool" event handlers not removed'
    assert_nil obj.listeners('whats-that'), '"whats-that" event handlers not removed'
  end

  def test_adding_one_time_handler
    obj = DummyClass.new
    handler = ->() { }

    obj.once('something-cool', handler)
    obj.emit('something-cool')

    assert_empty obj.listeners('something-cool')
  end

  def test_one_time_handler_does_not_stomp_args
    obj = DummyClass.new
    handler = MiniTest::Mock.new
    handler.expect(:call, 42, ['rock-on'])

    obj.once('something-cool', handler)
    obj.emit('something-cool', 'rock-on')
    handler.verify
  end
end