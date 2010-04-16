require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Thing do
  
  before(:each) do
    @things = stub :things
    @window = stub :window, :things => @things
    @thing = Thing.new @window
  end
  
  describe 'collision_type=' do
    before(:each) do
      @shape = stub :shape
      @thing.stub! :shape => @shape
    end
    it 'should delegate to the shape' do
      @shape.should_receive(:collision_type).once.with :some_collision_type

      @thing.collision_type :some_collision_type
    end
  end

  describe "current_size" do
    it "should return [1.0, 1.0] by default" do
      @thing.current_size.should == [1.0, 1.0]
    end
  end
  
  describe "draw" do
    before(:each) do
      @image = stub :image
      @thing.stub! :image            => @image,
                   :position         => Struct.new(:x, :y).new(:some_x, :some_y),
                   :layer            => :some_layer,
                   :drawing_rotation => :some_drawing_rotation,
                   :current_size     => [:size_x, :size_y]
    end
    context 'debug on' do
      
    end
    context 'debug off' do
      before(:each) do
        @window.stub! :debug? => false
      end
      it "should delegate to the image" do
        @image.should_receive(:draw_rot).once.with :some_x, :some_y, :some_layer, :some_drawing_rotation, 0.5, 0.5, :size_x, :size_y
        
        @thing.draw
      end
    end
  end
  
  describe "add_to" do
    before(:each) do
      @environment = stub :environment, :null_object => true
      @body  = stub :body
      @shape = stub :shape, :body => @body
      @thing.stub! :shape => @shape
    end
    it "should add its body to the given environment" do
      @environment.should_receive(:add_body).once.with @body
      
      @thing.add_to @environment
    end
    it "should add its shape to the given environment" do
      @environment.should_receive(:add_shape).once.with @shape
      
      @thing.add_to @environment
    end
  end
  
  describe "threaded" do
    before(:each) do
      @scheduling = stub :scheduling
      @window.stub! :scheduling => @scheduling
    end
    it "should delegate to the window" do
      some_block = Proc.new {}
      
      @scheduling.should_receive(:add).once.with :some_time, &some_block
      
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
        @things.stub! :remove => nil
      end
      it "should remove" do
        @things.should_receive(:remove).once.with @thing
        
        @thing.destroy!
      end
      it "should set destroyed" do
        @thing.should_receive(:destroyed=).once.with true
        
        @thing.destroy!
      end
    end
  end
  
  describe "destroyed?" do
    it "should be nil after creating the object" do
      @thing.destroyed?.should == nil
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
        class Thong < Thing
          layer :non_default_layer
        end
      end
      it "should be on the non default layer" do
        Thong.new(@window).layer.should == :non_default_layer
      end
    end
  end
  
end