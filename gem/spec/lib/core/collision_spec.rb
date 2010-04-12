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
    
  describe "constants" do
    it "should be nil" do
      Collision::None.should == nil
    end
    it "should be an empty lambda" do
      Collision::Simple.call # well, Collision should not receive anything
    end
  end
  
end