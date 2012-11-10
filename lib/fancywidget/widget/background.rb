module FancyWidget
  class Background

    attr_accessor :fill

    def update_layout
    end

    def paint
      canvas.fill_rect(rect, fill) if fill
    end

  end
end