module FancyWidget
  class Border
    attr_accessor :color, :width

    def initialize(color, width)
      @color = color
      @width = width
    end
  end
end