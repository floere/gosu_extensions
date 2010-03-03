module Shot
  
  attr_accessor :velocity, :lifetime, :originator
  
  def shoot_from shooter
    self.position = shooter.muzzle_position
    self.originator = shooter
    @window.register self
    threaded lifetime do
      @window.unregister self
    end
    self
  end
  
end