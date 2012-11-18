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

  class Window
    def stack(attributes = nil, &block)
      stack = Stack.new(current_container, attributes)
      with_container(stack) do
        self.instance_exec(&block)
      end
      stack
    end
  end
end