module Gui
  include FancyWidget
  class << self
    def app(&block)
      app = FancyWidget::Application.new
      window = FancyWidget::Window.new
      if block
        block.arity < 1 ? window.instance_eval(&block) : block[window]
      end
      app.run(window)
    end
  end
end