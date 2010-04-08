# A thing that is a pod can have attachments.
#
#
#
#
module Pod extend Trait
  
  manual <<-MANUAL
    Defines:
      attach <class>, x_pos, y_pos
    
    Example:
      class Battleship
        attach Cannon, 10, 20
  MANUAL
  
  def self.included target_class
    target_class.extend ClassMethods
    target_class.holds_attachments
    target_class.send :include, InstanceMethods
  end
  
  #
  #
  module ClassMethods
    
    def holds_attachments
      class_inheritable_accessor :prototype_attachments
      hook = lambda do
        self.class.prototype_attachments.each do |type, x, y|
          attach type.new(self.window), x, y
        end
      end
      InitializerHooks.append self, &hook
    end
    
    # Example:
    # class MotherShip
    #   is_a Pod
    #   attach Cannon, 10, 10
    #   attach Cannon, 20, 10
    #   attach Cannon, 30, 10
    #
    def attach type, x, y
      self.prototype_attachments ||= []
      self.prototype_attachments << [type, x, y]
    end
    
  end
  
  module InstanceMethods
    
    def materialize attachment
      attachment.extend Attachable # This is where Ruby shines.
      window.register attachment
    end
    
    #
    #
    def attachments
      @attachments || @attachments = []
    end
    
    #
    #
    def attach attachment, x, y
      # TODO Move to better place.
      self.class.alias_method_chain :move, :attachments unless respond_to?(:move_without_attachments)
      #
      materialize attachment
      attachment.relative_position = CP::Vec2.new x, y
      attachments << attachment
    end
    
    #
    #
    def detach attachment
      self.attachments.delete attachment if self.attachments
    end
    
    #
    #
    def move_attachments
      self.attachments.each do |attachment|
        attachment.move_relative self
      end
    end
    
    #
    #
    def move_with_attachments
      move_attachments
      move_without_attachments
    end
    # alias_method_chain :move, :attachments
    
  end
  
end