module Shoes
  class Window < Flow

    attr_accessor :title, :icon, :resizable
    attr_accessor :canvas

    include TextStyle

    def default_styles
      super.merge({
        title: 'Shoes',
        width: 600,
        height: 400,
        fill: :white,
        color: :black,
        font: Font.new("Georgia", 16)
      })
    end

    def initialize(attributes = nil)
      super(nil, attributes)
      @canvas = CairoCanvas.new(size)
    end

    def paint
      super
      @canvas.flush
    end

  end
end