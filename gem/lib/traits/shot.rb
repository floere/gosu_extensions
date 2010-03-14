module Shot
  
  #
  #
  attr_accessor :velocity, :originator
  
  #
  #
  def shoot_from shooter
    self.position = shooter.muzzle_position
    self.originator = shooter
    self.window.register self
    self
  end
  
end