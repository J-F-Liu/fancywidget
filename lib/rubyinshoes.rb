module Shoes

require_relative 'shoes/application'
require_relative 'shoes/style'
require_relative 'shoes/widget'
require_relative 'shoes/canvas'
require_relative 'shoes/canvas/cairocanvas'

class AbstractMethodError < StandardError
  def initialize
    super "Abstract method need be implemented in descendant class or object."
  end
end

class << self
  def app(&block)
    app = Application.new
    window = Window.new
    if block
      block.arity < 1 ? window.instance_eval(&block) : block[window]
    end
    app.run(window)
  end
end
end