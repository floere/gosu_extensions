class BlackHole < Thing
  
  attr_accessor :souls_needed
  
  it_has UserInterface
  
  image 'black_hole.png'
  
  shape :circle, 30.0
  mass 100_000_000_000
  moment 100
  friction 10.0
  
  collision_type :black_hole
  
  def initialize *args
    super
    self.souls_needed = 20
    self.torque = 1
  end
  
  def baby_consumed
    self.souls_needed -= 1
  end
  
  def finished?
    self.souls_needed.zero?
  end
  
end