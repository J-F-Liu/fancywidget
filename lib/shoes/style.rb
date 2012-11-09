
class Module
  def attr_inheritable(*attrs)
    attrs.each do |name|
       define_method(name) {
        raise "not called in widget class" if not respond_to? :owner
        var = "@#{name}"
        obj = self
        until val = obj.instance_variable_get(var)
          obj = obj.owner
          break if obj.nil?
        end
        return val
      }
      define_method("#{name}=") { |val|
        var = "@#{name}"
        instance_variable_set(var, val)
      }
    end
  end
end

module Shoes

  module BoxStyle
    attr_accessor :left, :top, :right, :bottom
    attr_accessor :width, :height
    attr_accessor :hidden, :collapsed
    attr_accessor :margin
    attr_accessor :margin_left
    attr_accessor :margin_top
    attr_accessor :margin_right
    attr_accessor :margin_bottom
    attr_accessor :border
    attr_accessor :padding
  end

  module ShapStyle
    # fill color
    attr_inheritable :fill

    # stroke color
    attr_inheritable :stroke

    attr_inheritable :strokewidth
  end

  module TextStyle
    attr_inheritable :font
    attr_inheritable :family
    attr_inheritable :fontsize

    # The boldness of the text. Commonly, this style is set to one of the following strings:
    # "ultralight" - the ultralight weight (= 200)
    # "light" - the light weight (=300)
    # "normal" - the default weight (= 400)
    # "semibold" - a weight intermediate between normal and bold (=600)
    # "bold" - the bold weight (= 700)
    # "ultrabold" - the ultrabold weight (= 800)
    # "heavy" - the heavy weight (= 900)
    # However, you may also pass in the numerical weight directly.
    attr_inheritable :weight

    attr_inheritable :stretch
    attr_inheritable :color
    attr_inheritable :align
    attr_inheritable :justify
    attr_inheritable :kerning
    attr_inheritable :leading
    attr_accessor :rise
    attr_accessor :emphasis

    # Vary the font for a group of text. Two choices:
    # "normal" - standard font.
    # "smallcaps" - font with the lower case characters replaced by smaller variants of
    # the capital characters.
    attr_accessor :variant

    # "none" - no underline at all.
    # "single" - a continuous underline.
    # "double" - two continuous parallel underlines.
    # "low" - a lower underline, beneath the font baseline. (This is generally
    # recommended only for single characters, particularly when showing keyboard
    # accelerators.)
    # "error" - a wavy underline, usually found indicating a misspelling.
    attr_accessor :underline

    # The color used to underline text.
    attr_accessor :undercolor

    attr_accessor :strikethrough
    attr_accessor :strikecolor
  end
  
end