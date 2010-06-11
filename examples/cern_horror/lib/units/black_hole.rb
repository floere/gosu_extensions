class BlackHole < Thing
  
  attr_accessor :souls_needed
  
  it_has UserInterface
  
  layer Layer::Ambient
  
  image 'black_hole.png'
  
  shape :circle, 30.0
  mass 100_000_000_000
  moment 100
  friction 10.0
  
  collision_type :black_hole
  
  def initialize *args
    super
    self.souls_needed = 10
    self.torque = 0.5
  end
  
  def baby_consumed
    self.souls_needed -= 1
  end
  
  def finished?
    self.souls_needed.zero?
  end
  
  # TODO Maybe enlarge to fill full screen?
  #
  def current_size
    @cached_size ||= [5.0, 5.0]
  end
  
end