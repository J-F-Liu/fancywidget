module FancyWidget
  class Stack < Container

    def update_layout
      super
      y, w = 0, 0
      widgets.each do |widget|
        if not widget.collapsed?
          widget.left, widget.top = 0, y
          y += widget.height
          w = [w, widget.width].max
        end
      end
      self.width = w if self.width == :auto
      self.height = y if self.height == :auto
    end

  end

  class Container
    def stack(attributes = nil, &block)
      stack = Stack.new(self, attributes)
      count = widgets.length
      self.instance_exec(&block)
      if (added = widgets.length - count) > 0
        widgets.pop(added).each {|w| stack.add(w)}
      end
      widgets << stack
      stack
    end
  end
end