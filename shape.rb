class Shape

  @@SHAPES = nil
  @@grid = nil

  attr_accessor :fall_fast

  def load_shapes
    @@SHAPES = []
    open(FILE_SHAPES) do |file|
      @@SHAPES = file.read.split(/^\s*$\n/m).grep(/\S/).map do |pat|
        pattern = pat.gsub(/[^x-]+/, '')
        raise 'bad pattern' unless pattern.length == SHAPE_NUM_ROWS * SHAPE_NUM_COLS
        bool_array = []
        for row in (0 .. SHAPE_NUM_ROWS-1)
          bool_row = []
          for col in (0 .. SHAPE_NUM_COLS-1)
            c = pattern[row * SHAPE_NUM_COLS + col].chr
            raise 'bad char in pattern' unless ['x','-'].member?(c)
            bool_row << (c == 'x')
          end
          bool_array << bool_row
        end
        bool_array
      end
    end
  end

  def initialize_grid
    @@grid = Hash.new
    for	i in 0 .. ROWS-1
      @@grid[i] = Hash.new
      for j in 0..COLS-1
        @@grid[i][j] = false
      end
    end
  end

  def draw_grid(screen)
    for i in 0..ROWS-1
      for j in 0..COLS-1
        if @@grid[i][j]
          _draw_block(screen, i,j, @@grid[i][j])
        end
      end
    end
  end

  def compute_time_next_fall
    @time_next_fall = Clock.runtime + (@fall_fast ? 0 : @delay_ms)
  end


  def hits?
    for i in 0 .. SHAPE_NUM_ROWS-1
      for j in 0 .. SHAPE_NUM_COLS-1
        if @shape[i][j] then
          return true if (@row+i < ROWS) and (@col+j<COLS) and (@@grid[@row+i][@col+j])
          return true if (@row+i >= ROWS) # hits on bottom
          return true if (@col+j <0) or (@col+j>=COLS)
        end
      end
    end
    return false
  end



  def initialize(color, delay_ms = 500)
    load_shapes unless @@SHAPES
    initialize_grid unless @@grid
    @shape = @@SHAPES.random_element
    @row = 0
    @col = COLS / 2
    @color = color
    @delay_ms = delay_ms
    @fall_fast = false
    @stuck = false # is piece stuck
    @game_over = false
    compute_time_next_fall
  end

  def rotate_left
    @shape = @shape.rotate_left
    if hits? then @shape = @shape.rotate_right; end
  end

  def rotate_right
    @shape = @shape.rotate_right
    if hits? then @shape = @shape.rotate_left; end
  end

  def fall
    if Clock.runtime > @time_next_fall then
      @row += 1
      compute_time_next_fall
      if hits? then
        @row -=1 # move back up
        @stuck = true # set 'done' flag
        for i in (0 .. SHAPE_NUM_ROWS-1)
          for j in (0 .. SHAPE_NUM_COLS-1)
            if @shape[i][j] then
              @@grid[@row+i][@col+j] = @color
              if @row+i <= 0 then
                @game_over = true
              end
            end
          end
        end
      end
    end
  end

  def right
    @col += 1
    if hits? then @col -= 1; end
  end

  def left
    @col -= 1
    if hits? then @col +=1; end
  end

  # origin at top upper left
  def draw(screen)
    for i in (0 .. SHAPE_NUM_ROWS-1)
      for j in (0 .. SHAPE_NUM_COLS-1)
        if @shape[i][j] then
          _draw_block(screen, @row+i, @col+j, @color )
        end
      end
    end
  end

  # origin at top upper left
  def _draw_block(screen, row, col, color)
    screen.draw_box_s([MARGIN_LEFT + col*BLOCK_WIDTH, MARGIN_TOP + row*BLOCK_HEIGHT],
    [MARGIN_LEFT - 1 + (col+1)*BLOCK_WIDTH, MARGIN_TOP - 1 +(row+1)*BLOCK_HEIGHT],
    color)
  end

  def stuck?
    @stuck
  end

  def game_over?
    @game_over
  end

end


