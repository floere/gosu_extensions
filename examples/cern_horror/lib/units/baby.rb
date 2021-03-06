class Baby < Thing
  
  sequenced_image 'naked_man.png', 32, 32, 5
  
  shape :circle, 12
  mass 3_000
  moment 0.1
  friction 1.0
  
  collision_type :baby
  
  random_rotation
  
  def move
    self.rotation += rand / 1000
    self.speed += window.gravity_vector_for(self) / 300
  end
  
  def current_size
    size = window.gravity_vector_for(self).length/30
    [size, size]
  end
  
end