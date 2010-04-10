class Tree < Thing
  
  image 'tree.png'
  
  shape :circle, 30
  mass 1000
  moment 0.01
  friction 1000
  rotation -Math::PI/2
  
  collision_type :obstacle
  
  def move
    self.position.y -= window.steepness
    on_hitting_y { destroy!; return }
  end
  
end