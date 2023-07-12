# You are given the initial starting point (x,y) of a rover and the direction (N,S,E,W) it is facing.
# The rover receives a character array of commands.
# Implement commands that move the rover forward/backward (f,b).
# Implement commands that turn the rover left/right (l,r).
# Implement wrapping at edges. But be careful, planets are spheres.
# Implement obstacle detection before each move to a new square. If a given sequence of commands encounters an obstacle, the rover moves up to the last possible point, aborts the sequence and reports the obstacle.

class MarsRover
  DIRECTIONS = ['N', 'E', 'S', 'W'].freeze

  attr_accessor :x, :y, :direction
  def initialize(x, y, direction)
    @x = x
    @y = y
    @direction = direction
    @obstacle = ['y3', 'x3']
  end

  def execute(commands)
    commands.each do |command|
      case command
      when 'f'
        move_forward
      when 'b'
        move_backward
      when 'l'
        turn_left
      when 'r'
        turn_right
      else
        puts "Invalid command: #{command}"
      end

      if hit_obstacle?
        puts "you hit the obstacle"
        return 'You have been hit by an obstacle'
      end
    end

    report_position
  end

  def hit_obstacle?
    @x == @obstacle[1][1].to_i && @y == @obstacle[0][1].to_i
  end

  def move_forward
    #The implementation takes into account the wrapping at the edges of the
    #planet by using the modulo operator (%) to wrap the coordinates within
    #the range of 0 to 99 (assuming a 100x100 grid).

    case @direction
    when 'N'
      @y = (@y + 1) % 100
    when 'E'
      @x = (@x + 1) % 100
    when 'S'
      @y = (@y - 1) % 100
    when 'W'
      @x = (@x - 1) % 100
    end
  end

  def move_backward
    case @direction
    when 'N'
      @y = (@y - 1) % 100
    when 'E'
      @x = (@x - 1) % 100
    when 'S'
      @y = (@y + 1) % 100
    when 'W'
      @x = (@x + 1) % 100
    end
  end

  def turn_left
    current_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_index - 1) % 4]
  end

  def turn_right
    current_index = DIRECTIONS.index(@direction)
    @direction = DIRECTIONS[(current_index + 1) % 4]
  end

  def report_position
    position = "Current position: #{@x}, #{@y}, #{@direction}"
    puts position
    position
  end
end

describe MarsRover do
  #Initialise with a starting point and direction

  context "initialise" do
    it 'has an X co-ordinate starting point' do
      mars_rover = MarsRover.new('1', '1', 'N')
      expect(mars_rover.x).to eq('1')
    end

    it 'has a Y co-ordinate starting point' do
      mars_rover = MarsRover.new('1', '1', 'N')
      expect(mars_rover.y).to eq('1')
    end

    it 'has a starting direction' do
      mars_rover = MarsRover.new('1', '1', 'N')
      expect(mars_rover.direction).to eq('N')
    end
  end

  context "move forward" do
    # Move forward - update Y or X depending on the direction faced.

    it "increments the Y axis when moving forward and direction is north" do
      mars_rover = MarsRover.new(0, 0, 'N')
      mars_rover.execute(['f'])
      expect(mars_rover.y).to eq(1)
    end

    it "increments the X axis when moving forward and direction is east" do
      mars_rover = MarsRover.new(0, 0, 'E')
      mars_rover.execute(['f'])
      expect(mars_rover.x).to eq(1)
    end

    it "decrements the Y axis when moving forward and direction is south" do
      mars_rover = MarsRover.new(0, 0, 'S')
      mars_rover.execute(['f'])
      expect(mars_rover.y).to eq(99)
    end

    it "decrements the X axis when moving forward and direction is west" do
      mars_rover = MarsRover.new(1, 1, 'W')
      mars_rover.execute(['f'])
      expect(mars_rover.x).to eq(0)
    end
  end

  context "move backward" do
    # Move backward - update Y or X depending on the direction faced.

    it "decrements the Y axis when moving backward and direction is north" do
      mars_rover = MarsRover.new(0, 1, 'N')
      mars_rover.execute(['b'])
      expect(mars_rover.y).to eq(0)
    end

    it "decrements the X axis when moving backward and direction is east" do
      mars_rover = MarsRover.new(1, 1, 'E')
      mars_rover.execute(['b'])
      expect(mars_rover.x).to eq(0)
    end

    it "increments the Y axis when moving backward and direction is south" do
      mars_rover = MarsRover.new(1, 1, 'S')
      mars_rover.execute(['b'])
      expect(mars_rover.y).to eq(2)
    end

    it "decrements the X axis when moving backward and direction is west" do
      mars_rover = MarsRover.new(1, 1, 'W')
      mars_rover.execute(['b'])
      expect(mars_rover.x).to eq(2)
    end
  end

  context "Turning" do
    # If I am facing NSEW, which way would I face if I turned left of right
    it "turns left when facing south" do
      mars_rover = MarsRover.new(1, 1, 'S')
      mars_rover.execute(['f', 'l'])
      expect(mars_rover.direction).to eq('E')
    end

    it "turns right when facing south" do
      mars_rover = MarsRover.new(1, 1, 'S')
      mars_rover.execute(['f', 'r'])
      expect(mars_rover.direction).to eq('W')
    end
  end

  context "report position" do
    it "reports position after moving" do
      mars_rover = MarsRover.new(1, 1, 'S')
      mars_rover.execute(['f', 'r'])

      expect(mars_rover.report_position).to eq("Current position: 1, 0, W")
    end
  end

  context "obstacle" do
    #Set obstacle co-ordinates and check if they are hit during journey execution
    it "exits when hitting an obstacle" do
      mars_rover = MarsRover.new(3, 2, 'N')
      mars_rover.execute(['f'])
      expect(mars_rover.hit_obstacle?).to eq(true)
    end

    it "exits when hitting an obstacle mid way through the journey" do
      mars_rover = MarsRover.new(3, 2, 'N')
      mars_rover.execute(['f', 'l'])
      expect(mars_rover.hit_obstacle?).to eq(true)
    end
  end
end