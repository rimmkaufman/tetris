require 'rubygame/sfont'

def draw_screen_border(screen)
  screen.draw_box([MARGIN_LEFT, MARGIN_TOP],[XMAX-MARGIN_RIGHT, YMAX-MARGIN_BOTTOM], COLOR_BOX)
end

def intro_screen(screen)
  clock = Clock.new { |c| c.target_framerate = 30 }
  queue = Rubygame::EventQueue.new
  continue_intro = true
  while continue_intro do
    queue.each do |e|
      if   (e.kind_of?(KeyDownEvent) and  e.key == K_Q) or e.kind_of?(QuitEvent)
        Rubygame.quit
        exit
      elsif e.kind_of?(KeyDownEvent) and e.key == K_SPACE
        continue_intro=false
      end
    end
    clock.tick
    background = Rubygame::Surface.new(screen.size)
    background.fill(COLOR_BACKGROUND)
    background.blit(screen, [0, 0]) # clear screen
    draw_screen_border(screen)
    render_text(screen, 'hi',30, BLACK, 50,50)
  end
end

def render_text(screen,string, font_size, color, x, y)
  font = Rubygame::TTF.new("FreeSans.ttf",font_size)
  text = font.render(string, true, color)
  textpos = Rubygame::Rect.new(0,0,*text.size)
  textpos.top = y
  textpos.left = x
  text.blit(screen,textpos)
end
