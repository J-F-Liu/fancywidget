module FancyWidget
  class Font
    attr_accessor :familly, :size

    def initialize(familly, size)
      @familly = familly
      @size = size
    end
  end
end