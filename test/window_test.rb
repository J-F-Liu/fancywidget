require 'minitest/autorun'
require_relative '../lib/rubyinshoes'

include Shoes

class WindowTest < MiniTest::Unit::TestCase
  def test_window_size
    window = Window.new nil
    assert_equal(600, window.width)
    assert_equal(:white, window.background)

    label = Label.new window
    assert_equal(:black, label.color)

    label.color = :red
    assert_equal(:red, label.color)
  end
end