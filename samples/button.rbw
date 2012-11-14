require_relative '../lib/fancywidget'

Gui.app {
 @lbl = label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'
 label 'Hello, world!'

 button('Click me').click {
   @lbl.color = cycle(red, green, blue)
 }
}