
require_relative 'canvas/color'
require_relative 'canvas/font'
require_relative 'canvas/border'

module FancyWidget
  class Canvas
    attr_accessor :size

    def initialize(size)
      @size = size
    end

    def fill_rect(rect, color)
    end

    def measure_text(font, text)
    end

    def draw_text(pos, font, color, text)
    end

    def fill_background(rect, background)
      case background
      when Symbol, Color
        fill_rect(rect, background)
      when Range
        fill_gradient(rect, background)
      when Pattern
        fill_pattern(rect, background)
      end
    end 

  end
end