
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
    attr_accessor :margin
    attr_accessor :boder
    attr_accessor :padding
    attr_accessor :background
  end

  module TextStyle
    attr_inheritable :font
    attr_inheritable :color
    attr_inheritable :char_spacing
  end
  
end