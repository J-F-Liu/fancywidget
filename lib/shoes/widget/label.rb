module Shoes
  class Label < Widget

    include BoxStyle
    include TextStyle

    attr_accessor :text

    def update_layout
      text_size = canvas.measure_text(font, text)
      @text_pos = [x, y + text_size[1]]
    end

    def paint
      canvas.draw_background(rect, background)
      canvas.draw_text(@text_pos, font, color, text)
    end

  end
end