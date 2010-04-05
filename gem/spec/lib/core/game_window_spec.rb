require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe GameWindow do
  
  class Gosu::Window
    def initialize(*)
      # Note: Let's not initialize a real window.
    end
  end
  
  class GameWindowTest < GameWindow
    def setup_font
      # Note: Causes errors, test separately.
    end
  end
  
  before(:each) do
    @window = GameWindowTest.new
  end
  
  describe "gravity and gravity_vector" do
    context 'default' do
      it "should have a calculated value" do
        @window.gravity_vector.x.should == 0.0
        @window.gravity_vector.y.should == 0.098
      end
    end
    context 'user defined' do
      before(:each) do
        GameWindowTest.gravity 100
        @window = GameWindowTest.new
      end
      it "should have a user defined value" do
        @window.gravity_vector.x.should == 0.0
        @window.gravity_vector.y.should == (100/SUBSTEPS)
      end
    end
  end
  
  describe "draw" do
    it "should call other draw methods in sequence" do
      @window.should_receive(:draw_background).once.with
      @window.should_receive(:draw_ambient).once.with
      @window.should_receive(:draw_moveables).once.with
      @window.should_receive(:draw_ui).once.with
      
      @window.draw
    end
  end
  
end