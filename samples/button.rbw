require_relative '../lib/fancywidget'

Gui.app {
  @lbl = label 'Hello, world!'
  label 'Hello, world!'
  label 'Hello, world!'
  label 'Hello, world!'
  stack {
    label 'Hello, world!'
    flow {
      label 'Hello, world!'
      label 'Hello, world!'}
    label 'Hello, world!'
   }
 
  button('Click me').click {
    @lbl.color = [red, green, blue, purple].sample
  }
}