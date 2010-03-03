# A thing that is a pod can have attachments.
#
#
#
#
module Pod
  
  def self.included target_class
    target_class.extend IncludeMethods
  end
  
  # TODO is_a Rack
  #
  # TODO Maybe
  #      is_a Rack.
  #           with(Cannon, 10, 10).
  #           with(Cannon, 20, 10)
  #
  module IncludeMethods
    
    def holds_attachments
      include InstanceMethods
      alias_method_chain :move, :attachments
      
      class_inheritable_accessor :prototype_attachments
      extend ClassMethods
      hook = lambda do
        self.class.prototype_attachments.each do |type, x, y|
          attach type.new(window), x, y
        end
      end
      InitializerHooks.register self, hook
    end
    
  end
  
  module ClassMethods
    
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
    
    attr_accessor :attachments
    
    #
    #
    def attach attachment, x, y
      self.attachments ||= []
      attachment.extend Attachable # This is where Ruby shines.
      window.register attachment
      attachment.rotation = self.rotation
      attachment.relative_position = CP::Vec2.new x, y
      self.attachments << attachment
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
    
  end
  
end