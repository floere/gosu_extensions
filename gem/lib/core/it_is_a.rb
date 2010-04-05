# Include helpers. Multiple Modules (Traits) can be named.
#
# Examples:
# * it_is_a Targetable, Accelerateable
# * it_is Targeting::Closest
#
module ItIsA
  
  manual <<-MANUAL
    Defines:
      it_is <some trait>
      it_is_a <some trait>
      it_has <some trait>
    
    Example:
      it_is Controllable
      it_is_a Generator
      it_has Lives
  MANUAL
  
  def self.included traitable_class
    traitable_class.extend ClassMethods
  end
  
  module ClassMethods
    
    #
    # Examples:
    # * it_is_a Shooter
    # * it_is_a Shooter do
    #     frequency 10
    #     …
    #   end
    # * it_is Controllable, Turnable do
    #     …
    #   end
    #
    def it_is *traits, &block
      traits.each { |trait| include trait }
      instance_eval &block if block_given?
    end
    alias it_is_a it_is
    alias it_has it_is
    
  end
  
end