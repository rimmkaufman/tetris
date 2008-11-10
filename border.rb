require 'rubygame/sfont'


class ShimmerColor

  @@steps = 60

  def initialize
    @curr = [rand(255), rand(255),rand(255)]
    @step = @@steps+1 # this force a new color on the first pass
    @inc = []
  end

  def next
    if (@step >= @@steps)
      @step = 0
      dest = [rand(255), rand(255),rand(255)]
      d = rand(3)
      dest[d] = 255*rand(2)
      3.times { |i| @inc[i] = (dest[i]-@curr[i])/@@steps.to_f }
      @inc[d] /= 2
    end
    3.times {|i| @curr[i] = @curr[i] + @inc[i]}
    @step += 1
    return self
  end

  def color
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
    clock.tick
    queue.each do |e|
      if   (e.kind_of?(KeyDownEvent) and  e.key == K_Q) or e.kind_of?(QuitEvent)
        Rubygame.quit
        exit
      elsif e.kind_of?(KeyDownEvent) and e.key == K_S
        continue_intro=false
      end
    end
    background = Rubygame::Surface.new(screen.size)
    background.fill(COLOR_BACKGROUND)
    background.blit(screen, [0, 0])
    draw_screen_border(screen)
    render_text(screen, 'tetris',130, shimmer.next.color, nil, 70)
    ypos = 250
    [
      'left arrow|left',
      'right arrow|right',
      'down arrow|down',
      'space|drop',
      '1|counter-clockwise',
      '2|clockwise',
      'n|new game',
      'c|cheat',
      'q|quit',
      ' | ',
      's|start|'
    ].each do |string|
      s1, s2 = string.split('|')
      render_text(screen, s1,14, GRAY, MARGIN_LEFT + 20, ypos)
      render_text(screen, s2,14, GRAY, MARGIN_LEFT + 180, ypos)
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
