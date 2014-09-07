require 'rspec'
require './game'

describe 'move_left' do
  let(:b) { new_board }

  it 'moves by one' do
    put_at b, 0, 1, 2
    move left, b
    expect(b[0]).to eq([2, nil, nil, nil])
  end

  it 'moves many places' do
    put_at b, 0, 3, 2
    move left, b 
    expect(b[0]).to eq([2, nil, nil, nil])
  end

  it 'does simple merge' do
    put_at b, 0, 0, 2
    put_at b, 0, 1, 2
    move left, b
    expect(b[0]).to eq([4, nil, nil, nil])
  end 

  it 'does complex merge' do
    (0..3).each { |i| put_at b, 0, i, 2 }
    move left, b
    expect(b[0]).to eq([8, nil, nil, nil])
  end

  it 'does not merge when impossible' do
    put_at b, 0, 1, 2
    put_at b, 0, 2, 4
    move left, b
    expect(b[0]).to eq([2, 4, nil, nil])
  end
end

describe 'mover right' do
  let(:b) { new_board }
  it 'moves many places' do
    put_at b, 0, 0, 2
    move right, b
    expect(b[0]).to eq([nil, nil, nil, 2])
  end  
end
