require 'cairo'
require 'pango'

module FancyWidget
  Color = Cairo::Color::RGB
  Pattern = Cairo::Pattern

  class CairoCanvas < Canvas

    def initialize(size)
      super(size)
      @surface = Cairo::ImageSurface.new(*size)
      @context = Cairo::Context.new(@surface)
    end

    def draw_rect(rect, color, line_width)
      @context.set_source_color(color)
      @context.rectangle(*rect)
      @context.set_line_width(line_width)
      @context.stroke
    end

    def fill_rect(rect, color)
      @context.set_source_color(color)
      @context.rectangle(*rect)
      @context.fill
    end

    def fill_gradient(rect, gradient)
      pattern = Cairo::LinearPattern.new(rect[0],rect[1],rect[0],rect[1]+rect[3])
      pattern.add_color_stop(0, gradient.begin)
      pattern.add_color_stop(1, gradient.end)
      fill_pattern(rect, pattern)
    end

    def fill_pattern(rect, pattern)
      @context.rectangle(*rect)
      @context.set_source(pattern)
      @context.fill
    end

    def measure_text(font, text)
      @context.select_font_face(font.familly)
      @context.set_font_size(font.size)
      extents = @context.text_extents(text)
      [extents.width, extents.height]
    end

    def draw_text(pos, font, color, text)
      @context.set_source_color(color)
      @context.select_font_face(font.familly)
      @context.set_font_size(font.size)
      @context.move_to(*pos)
      @context.show_text(text)
    end

    def data
      @surface.data
    end

    def flush
      @surface.flush
    end

    def output_png_file(file)
      @surface.write_to_png(file)
    end

  end
end