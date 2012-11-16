include FancyWidget
module Gui
  class << self
    def app(&block)
      app = Application.instance
      window = Window.new
      if block
        block.arity < 1 ? window.instance_exec(&block) : block[window]
      end
      app.run(window)
    end
  end
end