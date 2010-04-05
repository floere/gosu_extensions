# Any object that is targetable.
#
module Targetable extend Trait
  
  # Distance from the potential shooter.
  #
  def distance_from shooter
    (self.position - shooter.position).length
  end
  
end