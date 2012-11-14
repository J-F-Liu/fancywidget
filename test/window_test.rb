require 'minitest/autorun'
require_relative '../lib/fancywidget'

include FancyWidget

class WindowTest < MiniTest::Unit::TestCase
  def test_window_attr
    window = Window.new
    assert_equal(0, window.left)
    assert_equal(600, window.width)
    assert_equal(COLORS[:white], window.background)
    assert_equal(true, window.visible?)

    label = Label.new window
    assert_equal(0, label.left)
    assert_equal(COLORS[:black], label.color)

    label.color = :red
    assert_equal(:red, label.color)
  end
end