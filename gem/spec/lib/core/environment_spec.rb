require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Environment do
  
  before(:each) do
    @environment = Environment.new
  end
  
  it "should be a CP::Space" do
    @environment.should be_kind_of(CP::Space)
  end
  
  describe "remove" do
    before(:each) do
      @shape = stub :shape, :body => :some_body
      @thing = stub :thing, :shape => @shape
    end
    it "should description" do
      @environment.should_receive(:remove_body).once.with :some_body
      @environment.should_receive(:remove_shape).once.with @shape
      
      @environment.remove @thing
    end
  end
  
end