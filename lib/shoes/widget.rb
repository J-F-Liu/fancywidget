module Shoes

  class Widget

    attr_accessor :left, :top, :width, :height
    attr_accessor :visible, :collapsed
    attr_reader :owner

    def initialize(owner, attributes = nil)
      @owner = owner
      @left = 0
      @top = 0
      @width = 0
      @height = 0
      @visible = true
    end

    def visible?
      @visible ? true: false
    end

    def collapsed?
      @collapsed ? true: false
    end

    def show
      @visible = true
    end

    def hide
      @visible = false
    end

    def expand
      @collapsed = false
    end

    def collapse
      @collapsed = true
    end

    def window
      widget = self
      until widget.is_a? Window
        widget = widget.owner
        break if widget.nil?
      end
      widget
    end

    def canvas
      @canvas ||= window.canvas
    end

    def x
      x_pos = 0
      widget = self
      begin
        x_pos += widget.left
        widget = widget.owner
        break if widget.nil?
      end until widget.is_a? Window
      x_pos
    end

    def y
      y_pos = 0
      widget = self
      begin
        y_pos += widget.top
        widget = widget.owner
        break if widget.nil?
      end until widget.is_a? Window
      y_pos
    end

    def pos
      [x, y]
    end

    def rect
      [x, y, width, height]
    end

    def size
      [width, height]
    end

    def update_layout
      raise AbstractMethodError
    end

    def paint
      raise AbstractMethodError
    end

  end

  require_relative 'widget/container'
  require_relative 'widget/window'
  require_relative 'widget/stack'
  require_relative 'widget/label'
  require_relative 'widget/button'

end