module FancyWidget
  class Window < Flow

    attr_accessor :title, :icon, :resizable
    attr_accessor :canvas

    include TextStyle

    def default_styles
      super.merge({
        title: 'Fancy Widget',
        width: 600,
        height: 400,
        background: white,
        color: black,
        font: Font.new("Georgia", 16)
      })
    end

    def initialize(attributes = nil)
      super(nil, attributes)
      @canvas = CairoCanvas.new(size)
      @container_stack = [self]
    end

    def with_container(container)
      @container_stack.push container
      yield
    ensure
      @container_stack.pop
    end

    def current_container
      @container_stack.last
    end

    def paint
      super
      @canvas.flush
      @image = @canvas.data
      self.redraw
    end

    def onclick(x, y)
      super
      paint
    end

  end

  class Window
    def flow(attributes = nil, &block)
      flow = Flow.new(current_container, attributes)
      with_container(flow) do
        self.instance_exec(&block)
      end
      flow
    end
  end
end