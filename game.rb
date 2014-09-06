def new_board
  (1..4).map { (1..4).map { nil } }
end

def put_at(board, x, y, v) 
  board[x][y] = v
end

def move_left(board)
  board.each do |row|
    row.each_with_index do |value, column|
      shift_left row, value, column
    end
  end
end

def shift_left(row, value, column)
  if value && column > 0 && can_move_to(column - 1, value, row)
    if should_merge(column - 1, value, row)
      new_value = value * 2
    else
       new_value = value
    end
    row[column - 1] = new_value
    row[column] = nil
    shift_left row, new_value, column - 1
  end
end

def can_move_to(new_column, value, row)
  !row[new_column] || should_merge(new_column, value, row)
end

def should_merge(new_column, value, row) 
  row[new_column] == value
end



