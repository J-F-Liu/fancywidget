module FancyWidget
  class Window < Flow

    attr_accessor :title, :icon, :resizable
    attr_accessor :canvas

    include TextStyle

    def default_styles
      super.merge({
        title: 'Fancy Widget',
        width: 600,
        height: 400,
        background: white,
        color: black,
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
      @image = @canvas.data
      self.redraw
    end

    def onclick(x, y)
      super
      paint
    end

    def method_missing(name, *args)
      if COLORS.has_key?(name.to_sym)
        return COLORS[name.to_sym]
      else
        super
      end
    end

  end
end