
# require_relative 'canvas/color'
require_relative 'canvas/font'

module Shoes
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

    def draw_background(rect, background)
      case background
      when Symbol, Color
        fill_rect(rect, background)
      end
    end 

  end
end