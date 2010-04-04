require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Targetable do
  
  before(:each) do
    @targetable = Class.new do
      it_is Targetable
    end.new 
  end
  describe "distance_from" do
    before(:each) do
      @targetable.stub! :position => CP::Vector2.new(6, 8)
      @shooter = stub :shooter, :position => CP::Vector2.new(3, 4)
    end
    it "should return the right distance" do
      @targetable.distance_from(@shooter).should == 5.0
    end
  end
  
end