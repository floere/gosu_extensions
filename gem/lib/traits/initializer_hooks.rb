# def initialize
#   after_initialize
# end
# 
module InitializerHooks
  
  mattr_accessor :hooks # { class => [blocks] }
  self.hooks = {}
  
  # Calls the hooks in order of registration.
  #
  def after_initialize
    hooks = InitializerHooks.hooks[self.class]
    hooks && hooks.each do |hook|
      self.instance_eval &hook
    end
  end
  
  # Registers a hook for a class.
  #
  def self.register klass, &hook
    self.hooks[klass] ||= []
    self.hooks[klass] << hook
  end
  
  def self.prepend klass, &hook
    self.hooks[klass] ||= []
    self.hooks[klass].unshift hook
  end
  def self.append klass, &hook
    self.register klass, &hook
  end
  
end