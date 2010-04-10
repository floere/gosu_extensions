require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe RemoveShapes do
  
  before(:each) do
    @remove_shapes = RemoveShapes.new
  end
  
  it "should have no shapes, unprimed" do
    @remove_shapes.empty?.should == true
  end
  
  describe "add" do
    before(:each) do
      @shapes = stub :shapes
      @remove_shapes.stub! :shapes => @shapes
    end
    it "should << the shape to the shapes" do
      @shapes.should_receive(:<<).once.with :some_shape
      
      @remove_shapes.add :some_shape
    end
  end
  
  describe "remove_from" do
    context 'without shapes' do
      before(:each) do
        @remove_shapes.stub! :empty? => true
      end
      it "should just return" do
        @remove_shapes.should_receive(:shapes).never
        
        @remove_shapes.remove_from stub, stub
      end
    end
    context 'with shapes' do
      before(:each) do
        @shape = stub :shape
        @remove_shapes.stub! :empty? => false, :shapes => [@shape]
      end
      it "should remove the shapes from the environment and the moveables" do
        environment = stub :environment
        moveables   = stub :moveables
        
        environment.should_receive(:remove).once.with @shape
        moveables.should_receive(:remove).once.with @shape
        
        @remove_shapes.remove_from environment, moveables
      end
    end
  end
  
end