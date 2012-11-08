require 'cairo'
require 'pango'

module Shoes
  Color = Cairo::Color::RGB

  class CairoCanvas < Canvas

    def initialize(size)
      super(size)
      @surface = Cairo::ImageSurface.new(*size)
      @context = Cairo::Context.new(@surface)
    end

    def fill_rect(rect, color)
      @context.set_source_color(color)
      @context.rectangle(*rect)
      @context.fill
    end

    def measure_text(font, text)
      [100,font.size]
    end

    def draw_text(pos, font, color, text)
      @context.set_source_color(color)
      @context.select_font_face(font.familly)
      @context.set_font_size(font.size)
      @context.move_to(*pos)
      @context.show_text(text)
    end

    def save_to_image(file)
      @surface.write_to_png(file)
    end

  end
end