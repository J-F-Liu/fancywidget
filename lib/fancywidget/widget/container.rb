module FancyWidget
  class Container < Widget

    attr_accessor :widgets
    include ArgumentPaser

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
      canvas.fill_rect(rect, background) if background
      widgets.each do |widget|
        widget.paint if widget.visible?
      end
    end

  end
end