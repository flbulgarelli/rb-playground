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
  def fall_out?(slice_index)
    slice_index <= 0
  end
  def next(slice_index)
    slice_index - 1
  end
end

module Forward
  def fall_out?(slice_index)
    slice_index >= 3  
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


class Update
  def call(direction, index, value, slice)
    new_value = new_value(value)
    new_index = direction.next(index) 
    slice[new_index] = new_value
    slice[index] = nil
    shift direction, slice, new_value, new_index
  end
end

class Merge < Update
  def new_value(value)
    value * 2
  end
end

class Push < Update 
  def new_value(value)
    value
  end
end

class Skip
  def call(direction, index, value, slice)
  end
end

def move(direction, board)
  direction.slices(board).each do |slice|
    slice.each_with_index do |value, index|
      shift direction, slice, value, index
    end
  end
end

def shift(direction, slice, value, index)
  action = action_for_move(direction, index, value, slice)
  action.call(direction, index, value, slice) 
end

def action_for_move(direction, index, value, slice)
  new_index = direction.next(index)
  if !value || direction.fall_out?(index)
    Skip.new
  elsif !slice[new_index]
    Push.new
  elsif should_merge(new_index, value, slice)
    Merge.new
  else
    Skip.new
  end
end

def should_merge(new_index, value, slice) 
  slice[new_index] == value
end
