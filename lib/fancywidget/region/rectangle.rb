module FancyWidget
  class Rectangle
    attr_accessor :left, :top, :width, :height
    def initialize(left, top, width, height)
      if width < 0
        raise ArgumentError, "width should not be negative: #{width}"
      end
      if height < 0
        raise ArgumentError, "height should not be negative: #{height}"
      end
      @left, @top, @width, @height = left, top, width, height
    end

    def right
      @left + @width
    end

    def right=(value)
      @left = value - @width
    end

    def bottom
      @top + @height
    end

    def bottom=(value)
      @top = value - @height
    end

    def include?(x, y)
      x >= left and x <= right and y >= top and y <= bottom
    end
  end
end