require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Moveables do
  
  # TODO targeting
  
  describe "move" do
    before(:each) do
      @element1 = stub :element1
      @element2 = stub :element2
      @elements = [@element1, @element2]
      @moveables = Moveables.new @elements
    end
    it "should delegate to each" do
      @element1.should_receive(:move).once.with
      @element2.should_receive(:move).once.with
      
      @moveables.move
    end
  end
  
  describe "draw" do
    before(:each) do
      @element1 = stub :element1
      @element2 = stub :element2
      @elements = [@element1, @element2]
      @moveables = Moveables.new @elements
    end
    it "should delegate to each" do
      @element1.should_receive(:draw).once.with
      @element2.should_receive(:draw).once.with
      
      @moveables.draw
    end
  end
  
  describe "remove" do
    before(:each) do
      @ok    = stub :ok,    :shape => :the_shape_to_be_removed
      @wrong = stub :wrong, :shape => :not_the_right_shape
      @elements = [@wrong, @wrong, @ok, @wrong]
      @moveables = Moveables.new @elements
    end
    it "should remove the ok element" do
      @moveables.remove(:the_shape_to_be_removed).should == [@wrong, @wrong, @wrong]
    end
  end
  
  context 'default' do
    before(:each) do
      @elements  = stub :elements
      @moveables = Moveables.new @elements
    end
  
    describe "registered?" do
      context 'not yet registered' do
        before(:each) do
          @elements.should_receive(:include?).once.with(:some_moveable).and_return false
        end
        it "should return false" do
          @moveables.registered?(:some_moveable).should == false
        end
      end
      context 'already registered' do
        before(:each) do
          @elements.should_receive(:include?).once.with(:some_moveable).and_return true
        end
        it "should return true" do
          @moveables.registered?(:some_moveable).should == true
        end
      end
    end
  
    describe "register" do
      it "should register a moveable" do
        @elements.should_receive(:<<).once.with :some_moveable
      
        @moveables.register :some_moveable
      end
    end
  
    describe "each" do
      it "should delegate each to its elements" do
        @elements.should_receive(:each).once
      
        @moveables.each
      end
    end
  end
  
end