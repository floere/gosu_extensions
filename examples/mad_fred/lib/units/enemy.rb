class Enemy < Thing
  
  layer Layer::Players
  
  image 'enemy.png'
  
  shape :circle
  radius 21.0
  mass 100
  moment 0.1
  friction 10.0
  rotation -Math::PI/2
  
  collision_type :enemy
  
  # it_is_a Pod
  # attach Machinegun, 7, 25
  
  def move
    self.speed += random_vector
    self.position.x -= window.current_speed/4
    on_hitting_x { destroy!; return }
  end
  
end