require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Threading do
  
  before(:each) do
    @window = stub :window, :things => []
    @threaded = test_class_with(Threading).new @window
  end
  
  describe "sometimes" do
    it "should only call the block's content every x times" do
      @threaded.stub! :threaded => nil
      
      @threaded.sometimes(:some_id, :some_time) { :some_result }.should == :some_result
      @threaded.sometimes(:some_id, :some_time) { :some_result }.should == nil
      
      @threaded.instance_variable_set(:'@__sometimes_some_id', false)
      @threaded.sometimes(:some_id, :some_time) { :some_result }.should == :some_result
    end
  end
  
  describe "threaded" do
    before(:each) do
      @scheduling = stub :scheduling
      @window.stub! :scheduling => @scheduling
    end
    it "should delegate to the window's scheduling" do
      some_block = lambda {}
      @scheduling.should_receive(:add).once.with :some_time, &some_block
      
      @threaded.threaded :some_time, &some_block
    end
  end
  
end