require 'minitest/autorun'
require_relative '../lib/rubyinshoes'

include Shoes

class WindowTest < MiniTest::Unit::TestCase
  def test_window_attr
    window = Window.new
    assert_equal(0, window.left)
    assert_equal(600, window.width)
    assert_equal(:white, window.background)
    assert_equal(true, window.visible?)

    label = Label.new window
    assert_equal(0, label.left)
    assert_equal(:black, label.color)

    label.color = :red
    assert_equal(:red, label.color)
  end
end