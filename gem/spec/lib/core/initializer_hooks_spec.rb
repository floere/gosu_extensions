require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe InitializerHooks do
  
  before(:each) do
    @class = Class.new do
      include InitializerHooks
      def initialize
        after_initialize
      end
      def to_s
        "TestClass"
      end
    end
  end
  
  describe "register" do
    it "should instance eval the given hook on initializing" do
      InitializerHooks.register @class do
        raise "Hook called in #{self}"
      end
      
      lambda { @class.new }.should raise_error("Hook called in TestClass")
    end
  end
  
  describe "append" do
    it "should instance eval the given hook on initializing" do
      InitializerHooks.register @class do
        raise "Hook called in #{self}"
      end
      InitializerHooks.append @class do
        raise "Appended hook called in #{self}"
      end
      
      lambda { @class.new }.should raise_error("Hook called in TestClass")
    end
  end
  
  describe "prepend" do
    it "should instance eval the given hook on initializing" do
      InitializerHooks.register @class do
        raise "Hook called in #{self}"
      end
      InitializerHooks.prepend @class do
        raise "Prepended hook called in #{self}"
      end
      
      lambda { @class.new }.should raise_error("Prepended hook called in TestClass")
    end
  end
  
end