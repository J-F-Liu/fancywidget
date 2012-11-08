module Shoes
  class Stack < Container

    attr_accessor :widgets

    def update_layout
      raise AbstractMethodError
    end

    def paint
      widgets.each do |widget|
        widget.paint(canvas)
      end
    end

  end
end