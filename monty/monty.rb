class Array 
  def sample
    position = rand(length)
    self[position]
  end
end


class Scenario 
  @@dispositions = [ [:car, :goat, :goat], [:goat, :car, :goat], [:goat, :goat, :car] ]
  def initialize(disposition)
     @disposition = disposition
  end

  def choose(n)
    @first = n
    @open = pick_goat_other_than n
  end

  def pick_goat_other_than(n)
    @disposition.
       zip([0, 1, 2]).
       select { |value, index| value == :goat && index != n }.
       sample[1]
  end   

  def keep
    @last = @first
  end

  def swap
    @last = ([0, 1, 2] - [@first, @open])[0]
  end

  def won?
     @last == @disposition.index(:car)
  end
   

  def self.setup  
     Scenario.new(@@dispositions.sample)
  end

  def to_s
    "#{@disposition}:#{@first}:#{@open}:#{@last}"
  end
end

def run(strategy)
   s = Scenario.setup
   s.choose ([0, 1, 2].sample)
   s.send strategy
   s.won?
end
