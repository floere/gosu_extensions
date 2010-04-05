require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Thing do
  
  before(:each) do
    @window = stub :window
    @thing = Thing.new @window
  end
  
  describe "window" do
    it "should return the window" do
      @thing.window.should == @window
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