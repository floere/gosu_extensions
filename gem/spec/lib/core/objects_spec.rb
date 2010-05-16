require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Objects do
  
  before(:each) do
    @things  = stub :things
    @sprites = stub :sprites
    @objects = Objects.new @things, @sprites
  end
  
  describe "move" do
    it "should delegate move to both" do
      @things.should_receive(:move).once.with
      @sprites.should_receive(:move).once.with
      
      @objects.move
    end
  end
  
  describe "draw" do
    it "should delegate draw to both" do
      @things.should_receive(:draw).once.with
      @sprites.should_receive(:draw).once.with
      
      @objects.draw
    end
  end
  
  describe "remove_marked" do
    it "should delegate remove_marked to both" do
      @things.should_receive(:remove_marked).once.with
      @sprites.should_receive(:remove_marked).once.with
      
      @objects.remove_marked
    end
  end
  
end