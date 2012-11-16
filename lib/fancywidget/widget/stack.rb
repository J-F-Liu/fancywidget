module FancyWidget
  class Stack < Container

    def update_layout
      super
      y = 0
      widgets.each do |widget|
        if not widget.collapsed?
          widget.left, widget.top = 0, y
          y += widget.height
        end
      end
    end

  end
end