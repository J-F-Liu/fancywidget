module FancyWidget
  class Flow < Container

    def update_layout
      super
      x, y, w, h = 0, 0, 0, 0
      available_space = self.available_space
      widgets.each do |widget|
        if not widget.collapsed?
          if x > 0 and x + widget.width > available_space
            y += h
            w = [w, x].max
            x, h = 0, 0
          end
          widget.left, widget.top = x, y
          x += widget.width
          h = [h, widget.height].max
        end
      end
      if self.width == :auto
        self.width = [w, x].max
      end
      if self.height == :auto
        self.height = y + h
      end
    end
    
  end
end