module Shot extend Trait
  
  #
  #
  attr_accessor :velocity, :originator
  
  #
  #
  def shoot_from shooter
    self.position = shooter.muzzle_position
    self.originator = shooter
    self.show
    self
  end
  
end