class Cell
  attr_accessor :value
end

class Slice
  def initialize(values)
    @values = values
  end
  def []=(x, y) 
    @values[x].value = y
  end

  def [](x)
    @values[x].value
  end  

  def each(&b)
    to_a.each(&b)
  end

  def each_with_index(&b)
    to_a.each_with_index(&b)
  end

  def to_a
    @values.map(&:value)
  end
end

class Board
  attr_accessor :rows, :columns

  def initialize
    columns = []
    rows =    (0..3).map {     (0..3).map {     Cell.new   }  }
    columns = (0..3).map { |y| (0..3).map { |x| rows[x][y] }  }
    @rows    = rows.map    { |it| Slice.new(it) }
    @columns = columns.map { |it| Slice.new(it) }
  end

  def put_at(x, y, v) 
    @rows[x][y] = v
  end
end

class Left
  def move_within_board?(column)
    column > 0
  end
  def next(column)
    column - 1
  end
end

class Right 
  def move_within_board?(column)
    column < 3  
  end
  def next(column)
    column + 1
  end
end

def left
  Left.new
end
def right
   Right.new
end


def move(direction, board)
  board.rows.each do |row|
    row.each_with_index do |value, column|
      shift direction, row, value, column
    end
  end
end

def shift(direction, row, value, column)
  next_column = direction.next(column)
  if value && direction.move_within_board?(column) && can_move_to(next_column, value, row)
    if should_merge(next_column, value, row)
      new_value = value * 2
    else
      new_value = value
    end
    row[next_column] = new_value
    row[column] = nil
    shift direction, row, new_value, next_column
  end
end

def can_move_to(new_column, value, row)
  !row[new_column] || should_merge(new_column, value, row)
end

def should_merge(new_column, value, row) 
  row[new_column] == value
end



