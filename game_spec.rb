require 'rspec'
require './game'

describe 'move_left' do
  let(:b) { Board.new }

  it 'moves by one' do
    b.put_at 0, 1, 2
    move left, b
    expect(b.rows[0].to_a).to eq([2, nil, nil, nil])
  end

  it 'moves many places' do
    b.put_at 0, 3, 2
    move left, b 
    expect(b.rows[0].to_a).to eq([2, nil, nil, nil])
  end

  it 'does simple merge' do
    b.put_at 0, 0, 2
    b.put_at 0, 1, 2
    move left, b
    expect(b.rows[0].to_a).to eq([4, nil, nil, nil])
  end 

  it 'does complex merge' do
    (0..3).each { |i| b.put_at 0, i, 2 }
    move left, b
    expect(b.rows[0].to_a).to eq([8, nil, nil, nil])
  end

  it 'does not merge when impossible' do
    b.put_at 0, 1, 2
    b.put_at 0, 2, 4
    move left, b
    expect(b.rows[0].to_a).to eq([2, 4, nil, nil])
  end
end

describe 'mover right' do
  let(:b) { Board.new }
  it 'moves many places' do
    b.put_at 0, 0, 2
    move right, b
    expect(b.rows[0].to_a).to eq([nil, nil, nil, 2])
  end  
end
