require 'rubygame/sfont'


class ShimmerColor

  @@steps = 25

  def initialize
    @curr = [rand(255), rand(255),rand(255)]
    @step = @@steps+1 # this force a new color on the first pass
    @inc = []
  end

  def color
    if (@step >= @@steps)
      dest = [rand(255), rand(255),rand(255)]
      3.times { |i| @inc[i] = (dest[i]-@curr[i])/@@steps.to_f }
    end
    3.times {|i| @curr[i] = @curr[i] + @inc[i]}
    @step += 1
    return @curr
  end
end


def draw_screen_border(screen)
  screen.draw_box([MARGIN_LEFT, MARGIN_TOP],[XMAX-MARGIN_RIGHT, YMAX-MARGIN_BOTTOM], COLOR_BOX)
end

def intro_screen(screen)
  shimmer = ShimmerColor.new
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
    background.blit(screen, [0, 0])
    draw_screen_border(screen)
    render_text(screen, 'tetris',100, shimmer.color, nil, 180)
    ypos = 200
    [
      'LEFT ARROW    move shape left',
      'RIGHT ARROW   move shape right',
      'DOWN ARROW    move shape down',
      '    1         rotate shape left',
    '    2         rotate shape right'].each |s| do
      render_text(screen, string,20, shimmer.color, MARGIN_LEFT + 20, ypos)
      ypos += 20
    end
    screen.update
  end
end


def render_text(screen,string, font_size, color, x, y)
  font = Rubygame::TTF.new("FreeSans.ttf",font_size)
  text = font.render(string, true, color)
  textpos = Rubygame::Rect.new(0,0,*text.size)
  if !x then
    textpos.centerx = MARGIN_LEFT + COLS*BLOCK_WIDTH/2
  else
    textpos.left = x
  end
  textpos.top = y
  text.blit(screen,textpos)
end
