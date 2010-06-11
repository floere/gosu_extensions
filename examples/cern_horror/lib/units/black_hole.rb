class BlackHole < Thing
  
  it_has UserInterface
  
  image 'black_hole.png'
  
  shape :circle, 15.0
  mass 100_000_000_000
  moment 100
  friction 10.0
  
  collision_type :black_hole
  
  def initialize *args
    super
    self.torque = 1
  end
  
end