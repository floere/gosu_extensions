require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Collision do
  
  context 'with collision' do
    before(:each) do
      @some_function = lambda {}
      @collision = Collision.new :some_window, :this, :that, &@some_function
    end
    describe "install_on" do
      it "should install itself on the given thing correctly" do
        environment = stub :environment
        environment.should_receive(:add_collision_func).once.with :this, :that, &@some_function
        
        @collision.install_on environment
      end
    end
  end
  
  context 'no collision' do
    before(:each) do
      @collision = Collision.new :some_window, :this, :that, &Collision::None
    end
    describe "install_on" do
      it "should install itself on the given thing correctly" do
        environment = stub :environment
        environment.should_receive(:add_collision_func).once.with :this, :that, &Collision::None
        
        @collision.install_on environment
      end
    end
  end
  
  describe "complex_package" do
    before(:each) do
      @collision = Collision.new :some_window, :this, :that
    end
    it "should return a lambda with two params" do
      @collision.complex_package(lambda{}).arity.should == 2
    end
  end
  
  describe "simple_package" do
    before(:each) do
      @collision = Collision.new :some_window, :this, :that
    end
    it "should return a lambda with two params" do
      @collision.simple_package(lambda{}).arity.should == 2
    end
  end
  
  describe "package" do
    context 'definition with two params' do
      before(:each) do
        @definition = lambda { |one, two| }
        @collision = Collision.new :some_window, :this, :that, &@definition
      end
      it "should use the complex packaging" do
        @collision.should_receive(:complex_package).once.with @definition
        
        @collision.package @definition
      end
    end
    context 'definition with no params' do
      before(:each) do
        @definition = lambda { }
        @collision = Collision.new :some_window, :this, :that, &@definition
      end
      it "should use the simple packaging" do
        @collision.should_receive(:simple_package).once.with @definition
        
        @collision.package @definition
      end
    end
  end
    
  describe "constants" do
    it "should be nil" do
      Collision::None.should == nil
    end
    it "should be an empty lambda" do
      Collision::Simple.call # well, Collision should not receive anything
    end
  end
  
end