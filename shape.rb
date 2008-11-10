class Shape

  @@SHAPES = nil
  @@grid = nil
  @@rows_needing_evaporation = []

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
    @time_next_fall = Clock.runtime + (@fall_fast ? 0 : @fall_delay_ms)
  end

  def compute_time_next_move
    @time_next_move = Clock.runtime + MOVE_DELAY_MS
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

  def initialize(fall_delay_ms = 500)
    load_shapes unless @@SHAPES
    initialize_grid unless @@grid
    flavor = rand(@@SHAPES.length)
    @shape = @@SHAPES[flavor]
    @color = COLORS_SHAPES[flavor]
    @row = 0
    @col = COLS / 2
    @fall_delay_ms = fall_delay_ms
    @fall_fast = false
    @stuck = false # is piece stuck
    @game_over = false
    compute_time_next_fall
    compute_time_next_move
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
      down
      compute_time_next_fall
    end
  end

  def down
    @row += 1
    if hits? then
      @row -=1 # move back up
      @stuck = true # set 'done' flag
      copy_shape_to_grid
      compute_rows_needing_evaporation
      evaporate_rows if @@rows_needing_evaporation.length > 0
    end
  end

  def copy_shape_to_grid
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

  def right
    return if Clock.runtime < @time_next_move
    compute_time_next_move
    @col += 1
    if hits? then @col -= 1; end
  end

  def left
    return if Clock.runtime < @time_next_move
    compute_time_next_move
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

  def compute_rows_needing_evaporation
    @@rows_needing_evaporation = []
    for i in 0 .. ROWS-1
      evaporate = true
      for j in 0 .. COLS-1
        if !@@grid[i][j] then
          evaporate = false
          break
        end
      end
      @@rows_needing_evaporation.unshift(i) if evaporate
    end
  end

  def evaporate_rows
    @@rows_needing_evaporation.each do |r|
      (r-1).downto(0) do |i|
        for j in 0 .. COLS-1
          @@grid[i+1][j] = @@grid[i][j]
        end
      end
    end
  end


end


