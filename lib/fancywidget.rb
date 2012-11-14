module FancyWidget
  class AbstractMethodError < NotImplementedError
    def initialize
      super "Abstract method need be implemented in descendant class or object."
    end
  end
end

require_relative 'fancywidget/canvas'
require_relative 'fancywidget/region/rectangle'
require_relative 'fancywidget/application'
require_relative 'fancywidget/style'
require_relative 'fancywidget/widget'
require_relative 'fancywidget/canvas/cairocanvas'
require_relative 'fancywidget/platform/msw'
require_relative 'fancywidget/helper/kernel'
require_relative 'gui'