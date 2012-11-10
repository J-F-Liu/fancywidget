module FancyWidget
  module ArgumentPaser
    def parse_hash_and_object(list)
      if list.length > 0
        case list[0]
        when Hash
          hash = list[0]
          if list.length > 1
            obj = list[1]
          end
        else
          obj = list[0]
        end
      end
      return hash, obj
    end

    def parse_hash_and_string(list)
      if list.length > 0
        case list[0]
        when Hash
          hash = list[0]
          if list.length > 1 and list[1].is_a? String
            text = list[1]
          end
        when String
          text = list[0]
        end
      end
      return hash, text
    end
  end
end