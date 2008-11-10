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

# set up fonts
Rubygame::TTF.setup()


nav = {	K_RIGHT => {:state => false, :action => :right, :repeat=>true},
  K_LEFT=> {:state => false, :action => :left, :repeat => true},
  K_2 => {:state => false, :action => :rotate_right, :repeat=>false},
  K_1 => {:state => false, :action => :rotate_left, :repeat=>false},
  K_DOWN => {:state => false, :action => :down, :repeat=>true},
}

game_over = false
game_paused = false

while true do

  intro_screen(screen)

  queue = Rubygame::EventQueue.new
  clock = Clock.new { |c| c.target_framerate = 30 }

  until game_over do
    shape = Shape.new if !shape or shape.stuck?
    queue.each do |e|
      if   (e.kind_of?(KeyDownEvent) and  e.key == K_Q) or e.kind_of?(QuitEvent)
        Rubygame.quit
        exit
      elsif e.kind_of?(KeyDownEvent) and  e.key == K_ESCAPE
        game_paused = !game_paused
      elsif e.kind_of?(KeyDownEvent) and e.key == K_SPACE
        shape.fall_fast = !shape.fall_fast
      elsif e.kind_of?(KeyDownEvent) and nav.has_key?(e.key) then
        nav[e.key][:state] = true
      elsif e.kind_of?(KeyUpEvent) and nav.has_key?(e.key) then
        nav[e.key][:state] = false
      end
    end
    nav.values.each do |a|
      shape.send(a[:action]) if a[:state]
      a[:state] = false if !a[:repeat]
    end
    clock.tick
    background.blit(screen, [0, 0]) # clear screen
    draw_screen_border(screen)
    shape.fall
    if shape.game_over? then game_over = true; end
    shape.draw(screen)
    shape.draw_grid(screen)
    screen.update
  end

end
