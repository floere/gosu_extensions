# Use this if you need a closest targeting mechanism.
#
module Targeting
  
  module Closest extend Trait
    
    # Returns the closest target of all targets in the fire arc.
    #
    # TODO fire arc
    #
    def acquire *targets
      targets.sort_by {|target| distance = (target.position - self.position).length }.first
    end
  end
  
end