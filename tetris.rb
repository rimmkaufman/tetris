require 'rubygame'
require 'const'
require 'border'
require 'core'
require 'shape'
require 'pp'

include Rubygame


Rubygame.init
screen = Rubygame::Screen.set_mode [XMAX, YMAX]
screen.title = 'Tetris'
screen.fill CLR_BACKGROUND

shape = Shape.new(BLACK)
shape.draw(screen)

draw_screen_border(screen)
screen.update

queue = Rubygame::EventQueue.new

game_over = false

until game_over do
  queue.each do |event|
    case event
    when Rubygame::ActiveEvent
      screen.update
    when Rubygame::QuitEvent
      game_over = true
    end
  end
end

Rubygame.quit
