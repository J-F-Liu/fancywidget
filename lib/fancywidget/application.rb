module FancyWidget
  class Application
    attr_reader :main_window

    def initialize
    end

    def run(window)
      @main_window = window
      window.update_layout
      window.paint
      self.main_loop
    end

  end
end