require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Layer do
  it "should be the right layer" do
    Layer::Background.should == 0
  end
  it "should be the right layer" do
    Layer::Ambient.should == 1
  end
  it "should be the right layer" do
    Layer::Players.should == 2
  end
  it "should be the right layer" do
    Layer::UI.should == 3
  end
  it "should be the right layer" do
    Layer::Debug.should == 4
  end
end