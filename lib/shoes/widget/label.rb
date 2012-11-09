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
      canvas.fill_rect(rect, fill) if fill
      canvas.draw_text(@text_pos, font, color, text)
    end
  end

  class Container
    def label(*attributes_and_text)
      attributes, text = parse_hash_and_string(attributes_and_text)
      label = Label.new(self, attributes)
      label.text = text
      widgets << label
      label
    end
  end
end