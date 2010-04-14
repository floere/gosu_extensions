class Skier < Thing

  image 'skier/red.png'
  
  it_is Controllable
  it_is_a Generator
  it_has UserInterface
           
  it_has Lives
  lives 1
  
  shape :circle, 12
  mass 0.1
  moment 0.01
  friction 0
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
    
    if position.y < radius*2
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