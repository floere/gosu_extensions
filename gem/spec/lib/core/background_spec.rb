require File.join(File.dirname(__FILE__), '/../../spec_helper')

describe Background do
  
  context 'color config' do
    before(:each) do
      @window = stub :window, 
                     :background_options => Gosu::Color::WHITE
      @background = Background.new @window
    end
    it "should draw correctly" do
      @window.stub! :width => :some_width, :height => :some_height
      @window.should_receive(:draw_quad).once.with 0, 0, Gosu::Color::WHITE, :some_width, 0, Gosu::Color::WHITE, :some_width, :some_height, Gosu::Color::WHITE, 0, :some_height, Gosu::Color::WHITE, 0, :default
      
      @background.draw
    end
  end
  
  context 'image config' do
    before(:each) do
      Resources.stub! :root => 'some/root'
      @window = stub :window, :background_options => 'some/path.png'
      @image = stub :image
      Gosu::Image.stub! :new => @image
      @background = Background.new @window
    end
    it "should draw correctly" do
      @image.should_receive(:draw).once.with 0, 0, Layer::Background, 1.0, 1.0
      
      @background.draw
    end
  end
  
end