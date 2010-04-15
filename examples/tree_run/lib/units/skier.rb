class Skier < Thing
  
  it_is Controllable
  it_is_a Generator
  it_has UserInterface
           
  it_has Lives
  lives 1
  
  shape :poly, [CP::Vec2.new(-14,-8), CP::Vec2.new(-14,8), CP::Vec2.new(14,8), CP::Vec2.new(14,-8)]
  mass 85
  moment 100_000_000
  friction 100
  rotation -Rotation::Quarter
  
  collision_type :player
  
  attr_accessor :name, :points
  
  def initialize *args
    @points = 0
    super
  end
  
  def move
    bounce_off_border_x
    bounce_off_border_y
    
    if position.y < 24
      kill!
    end
  end
  
  def slam!
    generate Crash
    
    @points = 0
    
    kill!
  end
  
  def add_points
    @points += position.y / window.height
  end
  
end