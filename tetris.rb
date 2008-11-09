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

# for clearing the whole screen
background = Rubygame::Surface.new(screen.size)
background.fill(COLOR_BACKGROUND)

background.blit(screen, [0, 0]) # clear screen


draw_screen_border(screen)
screen.update

shape = Shape.new(BLACK)
shape.draw(screen)

nav = {	K_RIGHT => {:state => false, :action => lambda { shape.right}, :repeat=>true},
  K_LEFT=> {:state => false, :action => lambda { shape.left}, :repeat => true},
  K_2 => {:state => false, :action => lambda { shape.rotate_right}, :repeat=>false},
K_1 => {:state => false, :action => lambda { shape.rotate_left}, :repeat=>false}}

game_over = false
game_paused = false




queue = Rubygame::EventQueue.new
clock = Clock.new { |c| c.target_framerate = 30 }

until game_over do
  queue.each do |e|
    if   (e.kind_of?(KeyDownEvent) and  e.key == K_Q) or e.kind_of?(QuitEvent)
      game_over = true
    elsif e.kind_of?(KeyDownEvent) and  e.key == K_ESCAPE
      game_paused = !game_paused
    elsif e.kind_of?(KeyDownEvent) and e.key == K_SPACE
      shape.delay_ms = 0
    elsif e.kind_of?(KeyDownEvent) and nav.has_key?(e.key) then
      nav[e.key][:state] = true
    elsif e.kind_of?(KeyUpEvent) and nav.has_key?(e.key) then
      nav[e.key][:state] = false
    end
  end

  nav.values.each do |a|
    a[:action].call if a[:state]
    a[:state] = false if !a[:repeat]
  end

  clock.tick
  background.blit(screen, [0, 0]) # clear screen
  draw_screen_border(screen)
  shape.fall
  shape.draw(screen)
  shape.draw_grid(screen)
  screen.update
end

Rubygame.quit
