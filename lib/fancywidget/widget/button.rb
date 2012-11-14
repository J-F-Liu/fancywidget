module FancyWidget
  class Button < Widget

    attr_accessor :content
    include TextStyle

    # possible style settings:
    # nil - the control is active and editable.
    # "readonly" - the control is active but cannot be edited.
    # "disabled" - the control is not active (grayed out) and cannot be edited.
    attr_accessor :state

    def default_styles
      super.merge({
        padding: 4
      })
    end

    def update_layout      
      if content.is_a? String
        text_size = canvas.measure_text(font, content)
        @text_height = text_size[1]
        self.width = text_size[0] + padding * 2
        self.height = text_size[1] + padding * 2
      elsif content.is_a? Widget
        content.update_layout
      end
    end

    def paint
      canvas.fill_rect(rect, background) if background
      canvas.draw_rect(rect, color, 1)
      if content.is_a? String
        canvas.draw_text([x + padding, y + padding + @text_height], font, color, content)
      elsif content.is_a? Widget
        content.paint
      end
    end    
  end

  class Container
    def button(*attributes_and_content)
      attributes, content = parse_hash_and_object(attributes_and_content)
      button = Button.new(self, attributes)
      button.content = content
      widgets << button
      button
    end
  end
end