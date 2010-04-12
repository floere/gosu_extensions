class Skier < Thing

  image 'skier/red.png'
  
  it_is Controllable
  it_has UserInterface
           
  it_has Lives
  lives 1
  
  shape :circle, 12
  mass 0.1
  moment 0.01
  friction 0
  rotation -Math::PI/2
  
  collision_type :player
  
  attr_accessor :name, :points
  
  def initialize(*args)
    @points = 0
    super
  end
  
  def move
    bounce_off_border_x
    bounce_off_border_y
    
    if position.y < radius*2
      kill!
    end
  end
  
  def slam!
    crash = Crash.new(window)
    crash.warp position
    window.register crash
    
    @points = 0
    
    kill!
  end
  
  def add_points
    factor = position.y/window.height
    @points += factor
  end
  
end