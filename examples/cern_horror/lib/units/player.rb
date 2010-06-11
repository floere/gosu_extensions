class Player < Thing
  
  it_is Controllable
  it_has UserInterface
  
  # shape :poly, [CP::Vec2.new(-16,-16), CP::Vec2.new(-16,16), CP::Vec2.new(16,16), CP::Vec2.new(16,-16)]
  shape :circle, 16
  mass 85
  moment 0.1
  friction 10.0
  
  collision_type :player
  
  random_rotation
  
  attr_accessor :souls_saved
  
  def initialize *args
    super
    self.souls_saved = 0
  end
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 1000
    bounce_off_border_x
    bounce_off_border_y
  end
  
end