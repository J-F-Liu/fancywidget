require_relative '../lib/rubyinshoes'

app = Shoes.app { label "Hello, world!" }
app.main_window.canvas.save_to_image('window.png')