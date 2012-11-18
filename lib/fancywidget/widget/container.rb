module FancyWidget
  class Container < Widget

    attr_accessor :widgets
    include ArgumentPaser

    def default_styles
      super.merge({
        width: :auto,
        height: :auto
      })
    end

    def initialize(owner, attributes = nil)
      super
      @widgets = []
    end

    def available_space
      if width != :auto
        width
      else
        owner.available_space
      end
    end

    def update_layout
      widgets.each do |widget|
        widget.update_layout if not widget.collapsed?
      end
    end

    def paint
      canvas.fill_rect(rect, background) if background
      widgets.each do |widget|
        widget.paint if widget.visible?
      end
    end

    def onclick(x, y)
      super
      widgets.each do |widget|
        # alert "#{widget.rect.inspect} (#{x}, #{y})"
        if Rectangle.new(*widget.rect).include?(x, y)
          widget.onclick(x, y)
        end
      end
    end

  end
end