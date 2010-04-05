module SpecHelperHelpers
  
  def test_class
    Class.new Thing
  end
  
  def test_class_with mod, &block
    klass = test_class.send :include, mod
    klass.instance_eval &block if block_given?
    klass
  end
  
end