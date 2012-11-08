require 'minitest/autorun'
require_relative '../lib/rubyinshoes'

include Shoes

class WidgetTest < MiniTest::Unit::TestCase
  def test_widget_visibility
    widget = Widget.new nil
    assert_equal(true, widget.visible?)

    widget.hidden = true
    assert_equal(false, widget.visible?)

    widget.hidden = false
    assert_equal(true, widget.visible?)

    widget.hide
    assert_equal(false, widget.visible?)

    widget.show
    assert_equal(true, widget.visible?)
  end
end