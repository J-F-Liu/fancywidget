module Shoes
  class Button < Widget

    attr_accessor :content

    # possible style settings:
    # nil - the control is active and editable.
    # "readonly" - the control is active but cannot be edited.
    # "disabled" - the control is not active (grayed out) and cannot be edited.
    attr_accessor :state

    def paint
      canvas.draw_background(rect, background)
      if content.is_a? String
        canvas.draw_text(text)
      else
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