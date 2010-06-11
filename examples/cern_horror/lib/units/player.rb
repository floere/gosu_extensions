class Player < Thing
  
  it_is Controllable
  it_has UserInterface
  
  shape :circle, 12.0
  mass 100
  moment 0.1
  friction 10.0
  
  collision_type :player
  
  random_rotation
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 1000
    bounce_off_border_x
    bounce_off_border_y
  end
  
end