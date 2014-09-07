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
  def call(pointer)
    pointer.update new_value(pointer.value)
    pointer.shift
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
  def call(pointer)
  end
end

class Pointer
  attr_accessor :direction, :index, :slice

  def initialize(direction, index, slice)
    @direction = direction
    @index = index
    @slice = slice
  end

  def next_index
    direction.next(index)
  end

  def value
    slice[index]
  end

  def update(new_value)
    slice[next_index] = new_value
    slice[index] = nil
    self.index = next_index
  end

  def shift
    action_for_move.call(self)
  end

  def action_for_move
    if !value || direction.fall_out?(index)
      Skip.new
    elsif !slice[next_index]
      Push.new
    elsif should_merge(next_index, value, slice)
      Merge.new
    else
      Skip.new
    end
  end

  def should_merge(next_index, value, slice) 
    slice[next_index] == value
  end
end

class Slice
  def pointers(direction)
    to_a.map.with_index { |value, index| Pointer.new(direction, index, self)  }
  end
end

def move(direction, board)
  direction.slices(board).each do |slice|
    slice.pointers(direction).each &:shift
  end
end
