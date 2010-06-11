class Baby < Thing
  
  sequenced_image 'naked_man.png', 32, 32, 5
  
  shape :circle, 12
  mass 30
  moment 0.1
  friction 10.0
  
  collision_type :baby
  
  random_rotation
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 500
  end
  
end