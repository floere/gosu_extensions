# This is a convenience trait.
#
# Instead of calling
#   @controls << Control.new(self, @player1, :some_key_code => :action)
# you can define the controls in the object itself.
#
module Controllable extend Trait
  
  def self.included controllable
    controllable.extend ClassMethods
  end
  
  module ClassMethods
    
    # Enables to define the controls in the object itself, as in the Example:
    # 
    # class Spaceship < Thing
    #   it_is Controllable
    #   controls Gosu::Button::KbA     => Turnable::Left,
    #            Gosu::Button::KbD     => Turnable::Right,
    #            Gosu::Button::KbW     => Moveable::Accelerate,
    #            Gosu::Button::KbS     => Moveable::Backwards,
    #            Gosu::Button::KbSpace => Shooter::Shoot
    #
    def controls mapping
      attr_accessor :controls_mapping
      InitializerHooks.register self do
        self.controls_mapping = mapping
        self.controls
      end
    end
    
  end
  
  # You can add controls dynamically.
  #
  # Provide a hash of mappings:
  #   player_one.controls Gosu::Button::KbA => Turnable::Left,
  #                       Gosu::Button::KbD => Turnable::Right
  #
  def controls mapping = nil
    self.window.add_controls_for self, mapping
  end
  
end