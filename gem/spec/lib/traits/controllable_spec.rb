require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Controllable do
  
  before(:each) do
    @window = stub :window
  end
  
  describe "controls" do
    before(:each) do
      @controllable = test_class_with(Controllable).new @window
    end
    it "should return the mapping" do
      mapping = stub :mapping
      
      @window.should_receive(:add_controls_for).once.with @controllable, mapping
      
      @controllable.controls mapping
    end
  end
  
  describe "add_controls_for" do
    before(:each) do
      @controllable_class = test_class_with Controllable do
        controls :a => :b, :c => :d
      end
    end
    it "should return the mapping" do
      @window.should_receive(:add_controls_for).once
      
      @controllable_class.new @window
    end
  end
  
  describe "controls_mapping" do
    before(:each) do
      @window.stub! :add_controls_for => nil
      @controllable = test_class_with Controllable do
        controls :a => :b, :c => :d
      end.new @window
    end
    it "should return the mapping" do
      @controllable.controls_mapping.should == { :a => :b, :c => :d }
    end
  end
  
end