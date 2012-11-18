module FancyWidget
  class Label < Widget

    include BoxStyle
    include TextStyle

    attr_accessor :text

    def default_styles
      super.merge({
        padding: 6
      })
    end

    def update_layout
      text_size = canvas.measure_text(font, text)
      @text_height = text_size[1]
      self.width = text_size[0] + padding * 2
      self.height = text_size[1] + padding * 2
    end

    def paint
      super
      canvas.draw_text([x + padding, y + padding + @text_height], font, color, text)
    end
  end

  class Window
    def label(*attributes_and_text)
      attributes, text = parse_hash_and_string(attributes_and_text)
      label = Label.new(current_container, attributes)
      label.text = text
      label
    end
  end
end