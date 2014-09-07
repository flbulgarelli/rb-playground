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

module Backward
  def move_within_board?(slice_index)
    slice_index > 0
  end
  def next(slice_index)
    slice_index - 1
  end
end

module Forward
  def move_within_board?(slice_index)
    slice_index < 3  
  end
  def next(slice_index)
    slice_index + 1
  end
end

module Horizontal
  def slices(board)
    board.rows
  end
end

module Vertical 
  def slices(board)
     board.columns
  end
end

def left
  Object.new.extend Backward, Horizontal 
end
def right
  Object.new.extend Forward, Horizontal
end
def up
  Object.new.extend Backward, Vertical
end
def down
  Object.new.extend Forward, Vertical
end

def move(direction, board)
  direction.slices(board).each do |slice|
    slice.each_with_index do |value, index|
      shift direction, slice, value, index
    end
  end
end

def shift(direction, slice, value, index)
  next_index = direction.next(index)
  if value && direction.move_within_board?(index) && can_move_to(next_index, value, slice)
    if should_merge(next_index, value, slice)
      new_value = value * 2
    else
      new_value = value
    end
    slice[next_index] = new_value
    slice[index] = nil
    shift direction, slice, new_value, next_index
  end
end

def can_move_to(new_index, value, slice)
  !slice[new_index] || should_merge(new_index, value, slice)
end

def should_merge(new_index, value, slice) 
  slice[new_index] == value
end



