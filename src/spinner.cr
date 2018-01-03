class Spinner
  @state : Int32
  @cycle = ['⣷', '⣯', '⣟', '⡿', '⢿', '⣻', '⣽', '⣾']

  def initialize
    @state = 0
  end

  def spin
    @state += 1
    @state = @state % @cycle.size
  end

  def draw
    print "\b"
    print @cycle[@state]
  end
end
