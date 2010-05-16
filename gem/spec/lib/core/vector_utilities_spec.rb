require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe VectorUtilities do
  
  before(:each) do
    @vectored = Class.new { include VectorUtilities }.new
  end
  
  describe 'random_vector' do
    it 'should return a CP::Vec2' do
      @vectored.random_vector.should be_kind_of(CP::Vec2)
    end
    it "'s length should be defined by the param" do
      @vectored.random_vector(5).length.should == 5
    end
  end
  
end