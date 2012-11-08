module Shoes
  class Button < Widget

    attr_accessor :content

    def paint
      canvas.draw_background(rect, background)
      if content.is_a? String
        canvas.draw_text(text)
      else
        content.paint
      end
    end
    
  end
end