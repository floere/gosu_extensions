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
      self.prototype_attachments ||= []
      hook = lambda do |thing|
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
      self.prototype_attachments << [type, x, y]
    end
    
  end
  
  module InstanceMethods
    
    # Attach an instance to this.
    #
    def attach attachment, x, y
      # TODO Move to better place.
      self.class.alias_method_chain :move, :attachments unless respond_to?(:move_without_attachments)
      #
      materialize attachment
      attachment.relative_position = CP::Vec2.new x, y
      attachments << attachment
    end
    
    # Detach an instance from this.
    #
    def detach attachment
      if self.attachments
        detached = self.attachments.delete attachment
        detached.detached if detached # callback
      end
    end
    
    
    def materialize attachment
      attachment.extend Attachable # This is where Ruby shines.
      attachment.pod = self
      attachment.show
      attachment.attached
    end
    
    #
    #
    def attachments
      @attachments || @attachments = [] # TODO use Attachments.new
    end
    
    #
    #
    def move_attachments
      self.attachments.each do |attachment|
        attachment.move_relative
      end
    end
    
    #
    #
    def relative_position attachment
      self.position + attachment.relative_position.rotate(self.rotation_vector)
    end
    #
    #
    def relative_rotation attachment
      self.rotation + attachment.relative_rotation
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