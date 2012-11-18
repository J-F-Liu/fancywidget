module FancyWidget

  class Widget

    attr_reader :owner
    include BoxStyle
    include ShapStyle

    def default_styles
      {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
      }
    end

    def initialize(owner, attributes = nil)
      @owner = owner
      @owner.widgets << self if owner.is_a? Container
      if attributes.nil?
        attributes = default_styles
      else
        attributes = default_styles.merge attributes
      end
      set_attributes(attributes)
    end

    def set_attributes(attributes)
      attributes.each do |name, value|
        varname = "@#{name}"
        instance_variable_set(varname, value)
      end
    end

    def window(&block)
      widget = self
      until widget.is_a? Window
        widget = widget.owner
        break if widget.nil?
      end
      if widget and block
        widget.instance_exec(&block)
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

    def visible?
      !@hidden and !@collapsed
    end

    def collapsed?
      @collapsed ? true: false
    end

    def show
      @hidden = false
    end

    def hide
      @hidden = true
    end

    def toggle
      @hidden = !@hidden
    end

    def expand
      @collapsed = false
    end

    def collapse
      @collapsed = true
    end

    def update_layout
      raise AbstractMethodError
    end

    def paint
      canvas.fill_background(rect, background) if background
      canvas.draw_rect(rect, border.color, border.width) if border
    end

    def onclick(x, y)
      @click.call if @click
    end

    def click(&block)
      @click = block
    end

  end
end

require_relative 'helper/argumentpaser'
require_relative 'widget/container'
require_relative 'widget/flow'
require_relative 'widget/window'
require_relative 'widget/stack'
require_relative 'widget/label'
require_relative 'widget/button'