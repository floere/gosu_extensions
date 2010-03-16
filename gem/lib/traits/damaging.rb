# Use this for a thing that damages.
#
# Example:
#   class Rocket
#     it_is ShortLived
#     it_is Damaging
#   end
#
module Damaging
  
  mattr_accessor :damage
  
  def damage
    @@damage
  end
  
end