require_relative '../lib/rubyinshoes'

app = Shoes.app { label "Hello, world!" }
app.main_window.canvas.output_to_file('window.png')