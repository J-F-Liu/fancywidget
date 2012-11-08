module Shoes
  class Window < Container

    attr_accessor :title, :icon
    attr_accessor :canvas

    include BoxStyle
    include TextStyle

    def initialize(attributes = nil)
      super(nil, attributes)
      @width = 600 if @width == 0
      @height = 400 if @height == 0
      @background = :white if @background.nil?
      @color = :black if @color.nil?
      @font = Font.new "Georgia", 16
      @canvas = CairoCanvas.new(size)
    end

  end
end