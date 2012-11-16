module FancyWidget
  class Flow < Container

    def update_layout
      super
      x, y, h = 0, 0, 0
      single_row = true
      available_space = self.available_space
      widgets.each do |widget|
        if not widget.collapsed?
          if x > 0 and x + widget.width > available_space
            y += h
            x, h = 0, 0
            single_row = false
          end
          widget.left, widget.top = x, y
          x += widget.width
          h = [h, widget.height].max
        end
      end
      if single_row and self.width == :auto
        self.width = x
      end
      if self.height == :auto
        self.height = y + h
      end
    end
    
  end

  class Container
    def flow(attributes = nil, &block)
      flow = Flow.new(self, attributes)
      count = widgets.length
      self.instance_exec(&block)
      if (added = widgets.length - count) > 0
        widgets.pop(added).each {|w| flow.add(w)}
      end
      widgets << flow
      flow
    end
  end
end