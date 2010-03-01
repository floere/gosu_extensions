# Use this for a thing that damages.
#
# Example:
#   class Rocket < ShortLived
#     it_is Damaging
#   end
#
module Damaging
  
  mattr_accessor :damage
  
  def damage
    @@damage
  end
  
end