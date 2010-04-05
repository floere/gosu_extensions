require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Thing do
  
  before(:each) do
    @window = stub :window
    @thing = Thing.new @window
  end
  
  describe "threaded" do
    it "should delegate to the window" do
      some_block = Proc.new {}
      
      @window.should_receive(:threaded).once.with :some_time, &some_block
      
      @thing.threaded :some_time, &some_block
    end
  end
  
  describe "window" do
    it "should return the window" do
      @thing.window.should == @window
    end
  end
  
  describe "destroy!" do
    context 'already destroyed' do
      before(:each) do
        @thing.destroyed = true
      end
      it "should not unregister" do
        @window.should_receive(:unregister).never
        
        @thing.destroy!
      end
      it "should not set destroyed" do
        @thing.should_receive(:destroyed=).never
        
        @thing.destroy!
      end
    end
    context 'not yet destroyed' do
      before(:each) do
        @window.stub! :unregister => nil
      end
      it "should unregister" do
        @window.should_receive(:unregister).once.with @thing
        
        @thing.destroy!
      end
      it "should set destroyed" do
        @thing.should_receive(:destroyed=).once.with true
        
        @thing.destroy!
      end
    end
  end
  
  describe "destroyed?" do
    it "should be false after creating the object" do
      @thing.destroyed?.should == false
    end
  end
  describe "destroyed=" do
    it "should exist" do
      lambda { @thing.destroyed = true }.should_not raise_error
    end
  end
  
  describe "layer" do
    context 'default' do
      it "should be on the player layer" do
        @thing.layer.should == Layer::Players
      end
    end
    context 'non-default' do
      before(:each) do
        @thing.layer = :non_default_layer
      end
      it "should be on the non default layer" do
        @thing.layer.should == :non_default_layer
      end
    end
  end
  
end