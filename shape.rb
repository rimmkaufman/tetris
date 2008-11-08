class Shape

  @@SHAPES = nil

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

  def initialize(color)
    load_shapes unless @@SHAPES
    @shape = @@SHAPES.random_element
    @row = 0
    @col = COLS / 2
    @color = color
  end

  def fall
    @row += 1
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
end

