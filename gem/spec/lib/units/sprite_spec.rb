require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Sprite do
  
  before(:each) do
    @sprites = stub :sprites
    @window = stub :window, :sprites => @sprites
    @sprite = Sprite.new @window
  end

  describe "current_size" do
    it "should return [1.0, 1.0] by default" do
      @sprite.current_size.should == [1.0, 1.0]
    end
  end
  
  describe "draw" do
    before(:each) do
      @image = stub :image
      @sprite.stub! :image            => @image,
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
        
        @sprite.draw
      end
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
      
      @sprite.threaded :some_time, &some_block
    end
  end
  
  describe "window" do
    it "should return the window" do
      @sprite.window.should == @window
    end
  end
  
  describe "destroy!" do
    context 'already destroyed' do
      before(:each) do
        @sprite.destroyed = true
      end
      it "should not unregister" do
        @window.should_receive(:unregister).never
        
        @sprite.destroy!
      end
      it "should not set destroyed" do
        @sprite.should_receive(:destroyed=).never
        
        @sprite.destroy!
      end
    end
    context 'not yet destroyed' do
      before(:each) do
        @sprites.stub! :remove => nil
      end
      it "should remove" do
        @sprites.should_receive(:remove).once.with @sprite
        
        @sprite.destroy!
      end
      it "should set destroyed" do
        @sprite.should_receive(:destroyed=).once.with true
        
        @sprite.destroy!
      end
    end
  end
  
  describe "destroyed?" do
    it "should be nil after creating the object" do
      @sprite.destroyed?.should == nil
    end
  end
  describe "destroyed=" do
    it "should exist" do
      lambda { @sprite.destroyed = true }.should_not raise_error
    end
  end
  
  describe "layer" do
    context 'default' do
      it "should be on the player layer" do
        @sprite.layer.should == Layer::Ambient
      end
    end
    context 'non-default' do
      before(:each) do
        class Sprote < Sprite
          layer :non_default_layer
        end
      end
      it "should be on the non default layer" do
        Sprote.new(@window).layer.should == :non_default_layer
      end
    end
  end
  
end