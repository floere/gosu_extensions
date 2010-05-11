# def initialize
#   after_initialize
# end
# 
module InitializerHooks
  
  mattr_accessor :hooks # { class => [blocks] }
  self.hooks = {}
  
  # Runs the hooks for this instance for
  # each class and superclass up to Sprite.
  #
  def after_initialize
    self.class.ancestors.each do |klass|
      run_hooks_for klass
      break if klass == Sprite
    end
  end
  
  def run_hooks_for klass
    hooks = InitializerHooks.hooks[klass]
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