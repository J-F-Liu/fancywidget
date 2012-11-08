module Shoes
  class Container < Widget

    attr_accessor :widgets

    def initialize(owner, attributes = nil)
      super
      @widgets = []
    end

    def update_layout
      widgets.each do |widget|
        widget.update_layout if widget.visible?
      end
    end

    def paint
      canvas.draw_background(rect, background)
      widgets.each do |widget|
        widget.paint if widget.visible?
      end
    end

    def label(*attributes_and_text)
      if attributes_and_text.length > 0
        case attributes_and_text[0]
        when Hash
          attributes = attributes_and_text[0]
          if attributes_and_text.length > 1 and attributes_and_text[1].is_a? String
            text = attributes_and_text[1]
          end
        when String
          text = attributes_and_text[0]
        end
      end
      label = Label.new(self, attributes)
      label.text = text
      widgets << label
    end

  end
end