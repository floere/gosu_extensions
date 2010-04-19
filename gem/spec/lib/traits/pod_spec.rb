require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Pod do

  # describe "instance" do
  #   before(:each) do
  #     @things = stub :things, :null_object => true
  #     @window = stub :window, :things => @things
  #     @pod = test_class_with(Pod).new @window
  #   end
  #   describe "attach" do
  #     before(:each) do
  #       @attachable = Class.new(Thing) do
  #         shape :circle, 8
  #       end.new @window
  #     end
  #     it "should not fail" do
  #       lambda { @pod.attach(@attachable, 10, 20) }.should_not raise_error
  #     end
  #   end
  # end
  
  # describe "class traits" do
  #   before(:each) do
  #     @window = stub :window, :things => []
  #   end
  #   describe "attach" do
  #     before(:each) do
  #       klass = Class.new(Thing) do
  #         shape :circle, 10
  #       end
  #       @pod = test_class_with(Pod) do
  #         attach klass, 10, 10
  #       end.new @window
  #     end
  #     it "should have one attachment" do
  #       @pod.attachments.should == []
  #     end
  #   end
  # end
  
end