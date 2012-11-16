module FancyWidget
  class Flow < Container

    def update_layout
      super
      x, y, h = 0, 0, 0
      widgets.each do |widget|
        if not widget.collapsed?
          if x > 0 and x + widget.width > self.width
            x, y, h = 0, h, 0
          end
          widget.left, widget.top = x, y
          x += widget.width
          h = [h, widget.height].max
        end
      end
    end
    
  end
end