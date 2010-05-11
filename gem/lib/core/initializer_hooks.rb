# def initialize
#   after_initialize
# end
# 
module InitializerHooks
  
  mattr_accessor :hooks # { class => [blocks] }
  self.hooks = {}
  
  # Runs the hooks for this instance for
  # each class and superclass from Sprite on down.
  #
  def after_initialize
    relevant_ancestors.each { |klass| run_hooks_for klass }
  end
  
  # Relevant ancestors for self.
  #
  def relevant_ancestors
    ancestors = self.class.ancestors
    sprite? ? ancestors[0..ancestors.index(Sprite)] : ancestors[0..0]
  end
  
  # Is this class a sprite?
  #
  def sprite?
    is_a? Sprite
  end
  
  # Get and run the hooks for the class.
  #
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